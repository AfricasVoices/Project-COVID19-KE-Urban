#!/usr/bin/env bash

set -e

if [[ $# -ne 3 ]]; then
    echo "Usage: ./4_coda_add.sh <coda-auth-file> <coda-v2-root> <data-root>"
    echo "Uploads coded messages datasets from '<data-root>/Outputs/Coda Files' to Coda"
    exit
fi

AUTH=$1
CODA_V2_ROOT=$2
DATA_ROOT=$3

./checkout_coda_v2.sh "$CODA_V2_ROOT"


cd "$CODA_V2_ROOT/data_tools"
git checkout "9a9a8e708e3f20f37848a6b02f79bcee43e5be3b"  # (master which supports segmenting)

PROJECT_NAME="COVID19_KE_Urban"
DATASETS=(
    "s01e01"
)
for DATASET in ${DATASETS[@]}
do
    echo "Pushing messages data to ${PROJECT_NAME}_${DATASET}..."

    pipenv run python add.py "$AUTH" "${PROJECT_NAME}_${DATASET}" messages "$DATA_ROOT/Outputs/Coda Files/$DATASET.json"
done

PROJECT_NAME="COVID19"
DATASETS=(
    "location"
    "gender"
    "age"
)
for DATASET in ${DATASETS[@]}
do
    echo "Pushing messages data to ${PROJECT_NAME}_${DATASET}..."

    pipenv run python add.py "$AUTH" "${PROJECT_NAME}_${DATASET}" messages "$DATA_ROOT/Outputs/Coda Files/$DATASET.json"
done
