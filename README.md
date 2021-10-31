# Toucan Data Download

Fetch [Verra Registry][verra_registry] data for [Toucan][toucan] VCUs.

After downloading the registry CSV data, we filter for Toucan entries, and then replace the Verra methodology codes with descriptive titles.

## Pre-requisites

- make
- bash
- ruby

## Usage

Run `make`

Approximately 8 minutes later, you should have a file called `toucan-with-methodology.csv` like [this](https://gist.github.com/spikesolution/09b4b94f027bf4dfea483158193c3a49).

[verra_registry]: https://registry.verra.org/
[toucan]: https://registry.verra.org/
