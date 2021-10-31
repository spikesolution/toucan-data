#!/usr/bin/env ruby

# Script to transform a CSV file of Verra Registry data by replacing the "methodology" code with its full title.

require "csv"

# The lookup data is available in this gist:
# https://gist.github.com/spikesolution/3d735cb956af6129c5c5697340a7e03b
#
# To keep this file readable, I've only included codes which actually occur
# in Toucan VCS entries.
#
# NB: "AMS codes usually have a trailing period, e.g. "AMS-III.Z." but some of the
# CSV data omits the trailing period, so I'm removing it in this list, and from
# the code before looking it up.
#
METHODOLOGY_LOOKUP = {
  "AM0001" => "Decomposition of fluoroform (HFC-23) waste streams",
  "AM0009" => "Recovery and utilization of gas from oil fields that would otherwise be flared or vented",
  "AM0029" => "Baseline Methodology for Grid Connected Electricity Generation Plants using Natural Gas",
  "ACM0002" => "Grid-connected electricity generation from renewable sources",
  "ACM0006" => "Electricity and heat generation from biomass",
  "ACM0012" => "Waste energy recovery",
  "ACM0018" => "Electricity generation from biomass residues in power-only plants",
  "AMS-I.C" => "Thermal energy production with or without electricity",
  "AMS-I.D" => "Grid connected renewable electricity generation",
  "AMS-III.H" => "Methane recovery in wastewater treatment",
  "AMS-III.M" => "Reduction in consumption of electricity by recovering soda from paper manufacturing process",
  "AMS-III.Z" => "Fuel Switch, process improvement and energy efficiency in brick manufacture",
  "VM0004" => "Conservation Projects that Avoid Planned Land Use Conversion in Peat Swamp Forests",
  "VM0007" => "Reducing Emissions from Deforestation and Forest Degradation (REDD)",
  "VM0009" => "Avoided Ecosystem Conversion",
  "VM0010" => "Improved Forest Management",
  "VM0011" => "Preventing Planned Degradation",
  "VM0012" => "Improved Forest Management in Temperate and Boreal Forests (LtPF)",
  "VM0015" => "Avoided Unplanned Deforestation",
}

source_file = ARGV.shift || "toucan.csv"
dest_file = ARGV.shift || "toucan-with-methodology.csv"

data = CSV.read(source_file)
output_data = []

output_data.push(data.shift)  # Copy the header line as is

data.each do |row|
  # Some entries in the toucan.csv are missing the trailing "." for their methodology code,
  # so I'm trimming those before doing the lookup.
  code = row[7].sub(/\.$/, "")

  methodology = METHODOLOGY_LOOKUP[code]

  if methodology.nil?
    $stderr.puts "No lookup data found for methodology code #{code}"
    methodology = code
  end

  row[7] = methodology

  output_data.push(row)
end

# Output the updated CSV file
csv_options = {
  force_quotes: true,
  quote_char: '"',
}

CSV.open(dest_file, "wb", **csv_options) do |csv|
  output_data.each do |row|
    csv << row
  end
end

