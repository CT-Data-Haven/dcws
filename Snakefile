from pathlib import Path 
import pandas as pd 
from github import Github, Auth
import subprocess
from dotenv import load_dotenv
import os

load_dotenv()

def data_path(dataset, type = 'external'):
    if type == 'internal':
        return 'R/sysdata.rda'
    elif type == 'external':
        return f'data/{dataset}.rda'
    else:
        raise ValueError(f'Unknown data type: {type}')

def register_gh():
    gh = Github(auth = Auth.Token(os.getenv('GITHUB_PAT')))
    return gh

def get_latest_tag(repo, owner = 'ct-data-haven'):
    gh = register_gh()
    repo = gh.get_repo(f'{owner}/{repo}')
    latest = repo.get_latest_release().tag_name
    return latest

datasets = {
    # 'internal': ['full_meta'],
    'external': ['cws_group_meta', 'cws_full_data', 'cws_full_wts', 'cws_max_moe']
}
datasets = pd.concat([pd.DataFrame({'type': k, 'id': v}) for k, v in datasets.items()]).set_index('type')
datasets['path'] = datasets.apply(lambda x: data_path(x['id'], x.name), axis = 1)

repo24 = 'dcws24_crosstabs'
tag24 = get_latest_tag(repo24)

# scripts of functions that need tests
funcs = ['clean_dcws_lvls', 'parse_cws_paths', 'fetch_cws', 'read_cws', 'xtab2df']


rule download_2024:
    output:
        f'data-raw/crosstabs/downloads/dcws15_24-{tag24}.zip',
        f'data-raw/crosstabs/downloads/dcws24-{tag24}.zip',
    shell:
        '''
        # clean old downloads
        rm -f data-raw/crosstabs/dcws_*-v*.xlsx

        mkdir -p data-raw/crosstabs/downloads && touch data-raw/crosstabs/downloads/.dummy
        gh release download {tag24} --repo ct-data-haven/{repo24} \
            --pattern 'dcws*.zip' \
            --dir data-raw/crosstabs/downloads
        # unzip -j {output} -d data-raw/crosstabs
        for f in {output}; do unzip -j -o "$f" *.xlsx -d data-raw/crosstabs; done
        '''

rule cws20:
    input:
        xtab = 'data-raw/crosstabs/DataHaven2020 Connecticut Crosstabs.xlsx',
        doc = 'data-raw/misc_input/DataHaven0720_Prn2.docx',
    output:
        lookup = 'data/cws20_lookup.rda',
    script:
        'data-raw/cws20_lookup.R'

rule main_data:
    input:  
        xlsx = Path('data-raw/crosstabs').glob('*.xlsx'),
        scripts = ['R/parse_cws_paths.R', 'R/read_cws.R', 'R/clean_cws_lvls.R'],
        lookup20 = rules.cws20.output.lookup,
    output:
        # protected(datasets['path'].unique()),
        datasets['path'].unique(),
    script:
        'data-raw/prep_cws.R'


rule definitions:
    output:
        # protected('data/cws_defs.rda'),
        'data/cws_defs.rda',
    script:
        'data-raw/cws_definitions.R'

rule data_raw:
    input:
        rules.main_data.output,
        rules.definitions.output,
        rules.cws20.output,

rule tests:
    input:
        rules.data_raw.input,
        r = expand('R/{func}.R', func = funcs),
        test = expand('tests/testthat/test-{func}.R', func = funcs),
    shell:
        '''
        Rscript -e "devtools::test()"
        '''
    


rule check:
    input:
        rules.data_raw.input,
    output:
        flag = touch('.flags/pkg-check.txt'),
    shell:
        '''
        Rscript -e "devtools::build()"
        # Rscript -e "devtools::check(document = TRUE, cran = FALSE)"
        '''
    
rule install:
    input:
        data = rules.data_raw.input,
        check_flag = rules.check.output.flag,
    shell:
        'Rscript -e "devtools::install()"'

# use constraint with regex to match readme in base of directory
rule render_quarto:
    input:
        qmd = '{folder}{sep}{nb}.qmd',
    output:
        md = '{folder}{sep}{nb}.md',
    wildcard_constraints:
        folder = '.{0}|[a-z0-9-_]+',
        sep = '/?',
    shell:
        'quarto render {input.qmd}'

rule readme:
    input:
        check = rules.check.output.flag,
        # qmd = 'README.qmd',
        md = 'README.md',
    # output:

rule all:
    default_target: True
    input:
        rules.data_raw.input,
        rules.check.output.flag,
        'README.md',

rule clean:
    shell:
        '''
        rm -f .flags/* \
            man/*.Rd \
            data/*.rda \
            R/sysdata.rda \
            data-raw/crosstabs/downloads/*.zip \
            data-raw/crosstabs/dcws_*-v*.xlsx
        '''
