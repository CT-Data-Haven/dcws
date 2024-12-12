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

rule download_2024:
    output:
        f'data-raw/crosstabs/downloads/dcws15_24-{tag24}.zip',
        f'data-raw/crosstabs/downloads/dcws24-{tag24}.zip',
    shell:
        '''
        mkdir -p data-raw/crosstabs/downloads && touch data-raw/crosstabs/downloads/.dummy
        gh release download {tag24} --repo ct-data-haven/{repo24} \
            --pattern 'dcws*.zip' \
            --dir data-raw/crosstabs/downloads
        # unzip -j {output} -d data-raw/crosstabs
        for f in {output}; do unzip -j -o "$f" *.xlsx -d data-raw/crosstabs; done
        '''


rule data:
    input:
        xlsx = Path('data-raw/crosstabs').glob('*.xlsx'),
    output:
        # protected(datasets['path'].unique()),
        datasets['path'].unique(),
    script:
        'data-raw/prep_cws.R'


# depends on cws_full_data
rule definitions:
    input:
        defs = 'data-raw/misc_input/cws_defs_filled.csv',
        full_data = 'data/cws_full_data.rda',
    output:
        # protected('data/cws_defs.rda'),
        'data/cws_defs.rda',
    script:
        'data-raw/cws_definitions.R'


rule check:
    input:
        rules.data.output,
    output:
        flag = touch('.flags/pkg-check.txt'),
    shell:
        '''
        Rscript -e "devtools::build()"
        # Rscript -e "devtools::check(document = TRUE, cran = FALSE)"
        '''
    

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
        rules.data.output,
        # rules.definitions.output,
        rules.check.output.flag,
        'README.md',

rule clean:
    shell:
        '''
        rm -f .flags/* \
            man/*.Rd \
            data/*.rda \
            R/sysdata.rda \
            data-raw/crosstabs/downloads/*.zip
        '''
