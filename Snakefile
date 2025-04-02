from pathlib import Path
import pandas as pd
from github import Github, Auth
import subprocess
from dotenv import load_dotenv
import os

load_dotenv()

######################################
### FUNCTIONS                        ###
######################################
def flatten(xss):
    return [x for xs in xss for x in xs]


def switch_ext(path, ext):
    path = Path(path)
    return path.with_suffix(ext).name


def read_roxygen(path):
    with open(path, "r") as file:
        return [line.strip() for line in file if line.startswith("#'")]


def get_rd(path):
    path = Path(path)
    # read roxygen
    roxy = read_roxygen(path)
    # if has "@rdname" tag, use it
    # else use path stem
    rd = list(set([line for line in roxy if "@rdname" in line]))
    if len(rd) > 0:
        # return rd[0].split(' ')[2]
        return [r.split(" ")[2] for r in rd]
    else:
        return [path.stem]


def data_path(dataset, type="external"):
    if type == "internal":
        return "R/sysdata.rda"
    elif type == "external":
        return f"data/{dataset}.rda"
    else:
        raise ValueError(f"Unknown data type: {type}")


def register_gh():
    gh = Github(auth=Auth.Token(os.getenv("GITHUB_PAT")))
    return gh


def get_latest_tag(repo, owner="ct-data-haven"):
    gh = register_gh()
    repo = gh.get_repo(f"{owner}/{repo}")
    latest = repo.get_latest_release().tag_name
    return latest

######################################
### VARIABLES                        ###
######################################

# main datasets
datasets = {
    "internal": ["tags"],
    "external": [
        "cws_group_meta",
        "cws_full_data",
        "cws_full_wts",
        "cws_max_moe",
        "cws_codebook",
    ],
}
datasets = pd.concat(
    [pd.DataFrame({"type": k, "id": v}) for k, v in datasets.items()]
).set_index("type")
datasets["path"] = datasets.apply(lambda x: data_path(x["id"], x.name), axis=1)

# repo & tags to pull from latest github release
repo24 = "dcws24_crosstabs"
tag24 = get_latest_tag(repo24)

# scripts of functions that need tests
funcs = [
    f.stem for f in Path("R").glob("*.R") if f.stem not in ["data", "dcws-package", "zzz"]
]
# holdover from rmd vignettes
vignettes = [
    f.name for f in Path("vignettes").glob("*.Rmd")] + [
    f.name for f in Path("vignettes").glob("*.qmd")
]

# scripts of functions that have docs
doc_funcs = [f for f in funcs if f not in ["utils-misc", "parse_cws_paths"]]
# Rd files corresponding to documented functions' scripts
func_rds = flatten([get_rd(f"R/{func}.R") for func in doc_funcs])

######################################
### RULES                            ###
######################################

# rule comments idea from https://lachlandeer.github.io/snakemake-econ-r-tutorial/self-documenting-help.html
## download_2024: Download 2024 crosstabs from its repo and release
rule download_2024:
    output:
        f"data-raw/crosstabs/downloads/dcws15_24-{tag24}.zip",
        f"data-raw/crosstabs/downloads/dcws24-{tag24}.zip",
    shell:
        """
        # clean old downloads
        rm -f data-raw/crosstabs/dcws_*-v*.xlsx

        mkdir -p data-raw/crosstabs/downloads && touch data-raw/crosstabs/downloads/.dummy
        gh release download {tag24} --repo ct-data-haven/{repo24} \
            --pattern 'dcws*.zip' \
            --dir data-raw/crosstabs/downloads
        # unzip -j {output} -d data-raw/crosstabs
        for f in {output}; do unzip -j -o "$f" *.xlsx -d data-raw/crosstabs; done
        """

## main_data: Main internal/external datasets built from crosstab files
rule main_data:
    input:
        xlsx=Path("data-raw/crosstabs").glob("*.xlsx"),
        scripts=["R/parse_cws_paths.R", "R/read_cws.R", "R/clean_cws_lvls.R"],
        download=rules.download_2024.output,
    output:
        # protected(datasets['path'].unique()),
        datasets["path"].unique(),
    script:
        "data-raw/prep_cws.R"

## addl_data: Assorted other data following make_** pattern
rule addl_data:
    input:
        script = "data-raw/make_{dataset}.R",
    output:
        rda = "data/{dataset}.rda",
    shell:
        "Rscript {input.script}"

## data_raw: All data-creation rules
rule data_raw:
    input:
        rules.main_data.output,
        "data/cws_defs.rda",
        "data/cws_demo.rda",

## tests: Run tests for all corresponding function scripts
rule tests:
    input:
        rules.data_raw.input,
        r=expand("R/{func}.R", func=funcs),
        test=expand("tests/testthat/test-{func}.R", func=funcs),
    shell:
        """
        Rscript -e "devtools::test()"
        """

## document: All documentation - package description, function docs, data docs, vignettes, readme
rule document:
    input:
        desc="DESCRIPTION",
        r=expand("R/{func}.R", func=doc_funcs),
        data_doc="R/data.R",
        pkg_doc="R/dcws-package.R",
        vignettes=expand("vignettes/{v}", v=vignettes),
        readme="README.md",
    output:
        expand("man/{func}.Rd", func=func_rds),
        expand(
            "man/{dataset}.Rd",
            dataset=flatten([["cws_defs"], datasets.loc["external", "id"].tolist()]),
        ),
        "man/dcws-package.Rd",
        "NAMESPACE",
    shell:
        'Rscript -e "devtools::document()"'

## check: devtools check of data creation, tests, package description
rule check:
    input:
        rules.data_raw.input,
        rules.tests.input.test,
        desc="DESCRIPTION",
    output:
        flag=touch(".flags/pkg-check.txt"),
    shell:
        """
        Rscript -e 'devtools::check(
            document = TRUE, 
            cran = FALSE,
            args = c(\"--run-dontrun\")
            )'
        """

## install: Test that package can install
rule install:
    input:
        data=rules.data_raw.input,
        check_flag=rules.check.output.flag,
        desc="DESCRIPTION",
    output:
        flag=touch(".flags/install"),
    shell:
        'Rscript -e "devtools::install()"'


## pkgdown: Test that site can build
rule pkgdown:
    input:
        "_pkgdown.yml",
        rules.document.input,
    output:
        flag=touch(".flags/pkgdown"),
    shell:
        'Rscript -e "pkgdown::build_site()"'

## render_quarto: Wildcard rule to render qmd files in any directory
# use constraint with regex to match readme in base of directory
rule render_quarto:
    input:
        qmd="{folder}{sep}{nb}.qmd",
    output:
        md="{folder}{sep}{nb}.md",
    wildcard_constraints:
        folder=".{0}|[a-z0-9-_]+",
        sep="/?",
    shell:
        "quarto render {input.qmd}"

## readme: Render readme
rule readme:
    input:
        data = 'data/cws_full_data.rda',
        check=rules.check.output.flag,
        install = rules.install.output.flag,
        qmd = 'README.qmd',
    output:
        md="README.md",
    shell:
        "quarto render {input.qmd}"

## dag: Generate DAG
rule dag:
    input:
        "Snakefile",
    output:
        png="dag.png",
    shell:
        "snakemake --rulegraph | dot -T png > {output.png}"

## coverage: Generate test coverage report with codecov
rule coverage:
    output:
        report="coverage.html",
    shell:
        """
        Rscript -e "covr::report(
            covr::package_coverage(quiet = FALSE),
            file = \'coverage.html\',
            browse = FALSE
        )"
        """

## all: Default
rule all:
    default_target: True
    input:
        rules.dag.output.png,
        rules.data_raw.input,
        rules.check.output.flag,
        rules.pkgdown.output.flag,
        "README.md",

## clean: Remove flags, manpages, data, and crosstab downloads
rule clean:
    shell:
        """
        rm -f .flags/* \
            *.html \
            man/*.Rd \
            data/*.rda \
            R/sysdata.rda \
            data-raw/crosstabs/downloads/*.zip \
            data-raw/crosstabs/dcws_*-v*.xlsx
        """

## help: Print help, do nothing
rule help:
    input:
        'Snakefile',
    shell:
        'sed -n "s/^## /* /p" {input}'
