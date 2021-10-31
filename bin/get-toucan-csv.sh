#!/bin/bash

# Script to download Toucan-retired VCU data from the Verra Registry.
# The Verra API does not allow filtering on the value of "Retirement reason",
# so we have to download CSV data for all "retired" VCUs, and then filter
# those to get ones which mention the string 'TOUCAN'.
#
# NB: The string 'TOUCAN' appears at the start of the "Retirement reason" column
# for projects which were retired via the Toucan Bridge. However, if the
# same string appears in any other column, for unrelated reasons, that data
# will also be included in the final CSV file.
#
# By default, the script creates a 'verra.csv' file containing the CSV data
# for all retired offsets (as at 2021-10-28, this is 39MB), and a 'toucan.csv'
# file containing the data for Toucan-retired VCUs.
#
# As at 2021-10-28 the verra.csv file is approx. 39MB, and the script takes
# just over 7 minutes to run.

set -euo pipefail

FULL_CSV=verra.csv
TOUCAN_CSV=toucan.csv

fetch_data() {
  curl 'https://registry.verra.org/uiapi/asset/asset/search?$skip=0&count=true&$format=csv' \
    -X POST \
    -H 'Content-Type: application/json' \
    --compressed \
    --data-raw '{"program":"VCS","assetStatus":"RETIRED"}'
}

fetch_data > ${FULL_CSV}
head -1 ${FULL_CSV} > ${TOUCAN_CSV} # Get the CSV header line
grep TOUCAN ${FULL_CSV} >> ${TOUCAN_CSV} # Filter projects that mention "TOUCAN" (should be in the 'Retirement reason' column)

echo "Toucan VCU data downloaded to: ${TOUCAN_CSV}"
