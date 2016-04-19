# Tutorial: Data wrangling with SQLite

In this tutorial we learn how to use a relational database to merge and analyse CSV data from different sources.

The tutorial requires 
- [csvkit](https://csvkit.readthedocs.org/en/0.9.1/index.html) (optional)
- a sqlite database manager, either [sqlite](https://www.sqlite.org/download.html) or 
  alternatively [SQLite Manager for Firefox](https://addons.mozilla.org/en-US/firefox/addon/sqlite-manager/)

We will use the following data:
- [Glottolog languages and dialects](data/languages-and-dialects-geo.csv) downloaded from http://glottolog.org/static/download/2.7/languages-and-dialects-geo.csv
- [PHOIBLE phoneme data](data/phoible-by-phoneme.tsv) downloaded from https://raw.githubusercontent.com/phoible/dev/master/data/phoible-by-phoneme.tsv
- [Ecological data from D-PLACE](data/dplace-societies-2016-4-19.csv)

The tutorial is organized in a way that may resemble a typical usage for relational databases
in a research setting: Starting with a question

> Does our data allow any insight regarding the debate about effects of aridity/humidity on
> [tonality of languages](https://simple.wikipedia.org/wiki/Tone_language)?

we inspect available data, then procede to load this data into a relational database for further
processing, and finally export a dataset in CSV from the database which may serve as the basis for
further analysis.

## Sections

1. [Introduction to relational databases and SQL](01-introduction.md)
2. [CSV data](02-csv-data.md)
3. [Importing CSV data](03-importing-csv.md)
4. [Querying SQL databases](04-querying.md)
5. [Exporting CSV data](05-exporting-csv.md)
