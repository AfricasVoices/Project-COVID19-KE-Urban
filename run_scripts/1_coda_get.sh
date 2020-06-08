#!/usr/bin/env bash

set -e

if [[ $# -ne 3 ]]; then
    echo "Usage: ./1_coda_get.sh <coda-auth-file> <coda-v2-root> <data-root>"
    echo "Downloads coded messages datasets from Coda to '<data-root>/Coded Coda Files'"
    exit
fi

AUTH=$1
CODA_V2_ROOT=$2
DATA_ROOT=$3

./checkout_coda_v2.sh "$CODA_V2_ROOT"

cd "$CODA_V2_ROOT/data_tools"
git checkout "9a9a8e708e3f20f37848a6b02f79bcee43e5be3b"  # (master which supports segmenting)

mkdir -p "$DATA_ROOT/Coded Coda Files"

DATASETS=(
    "COVID19_s01e01"

    "COVID19_KE_Urban_s01e01"
    "COVID19_KE_Urban_s01e02"
    "COVID19_KE_Urban_s01e03"
    "COVID19_KE_Urban_s01e04"
    "COVID19_KE_Urban_s01e05"
    "COVID19_KE_Urban_s01e06"
    "COVID19_KE_Urban_s01e07"

    "COVID19_location"
    "COVID19_age"
    "COVID19_gender"
)
for DATASET in ${DATASETS[@]}
do
    echo "Getting messages data from ${DATASET}..."

    pipenv run python get.py "$AUTH" "${DATASET}" messages >"$DATA_ROOT/Coded Coda Files/$DATASET.json"
done
