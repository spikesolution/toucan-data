all:
	rm toucan-with-methodology.csv || true
	make toucan-with-methodology.csv

toucan.csv:
	bin/get-toucan-csv.sh

toucan-with-methodology.csv: toucan.csv
	bin/add-methodology-titles.rb toucan.csv toucan-with-methodology.csv
