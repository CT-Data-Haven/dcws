#!/usr/bin/env bash
# need repo, tag, output files
REPO="${snakemake_params[0]}"
TAG="${snakemake_params[1]}"
PATT="${snakemake_params[2]}"
# want output to break on spaces
FILES=${snakemake_output}
pwd

mkdir -p data-raw/crosstabs/downloads && touch "data-raw/crosstabs/downloads/.dummy-${TAG}"
gh release download "${TAG}" \
    --repo "ct-data-haven/${REPO}" \
    --pattern "${PATT}" \
    --dir data-raw/crosstabs/downloads \
    --clobber

for f in ${FILES}; do
    ext="${f##*.}"
    case $ext in
    zip)
        unzip -j -o "$f" *.xlsx -d data-raw/crosstabs;;
    gz)
        fn=$(basename "$f")
        cp "$f" data-raw/crosstabs
        gunzip -f "data-raw/crosstabs/$fn";;
    xlsx)
        fn=$(basename "$f" .xlsx)
        cp "$f" "data-raw/crosstabs/$fn-$TAG.xlsx"
    esac
done