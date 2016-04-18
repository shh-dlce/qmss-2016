# CSV data

We downloaded a CSV file containing data about languages and dialects from Glottolog and
a TSV file containing the PHOIBLE database on phoneme inventories (see [README](data/README.md)).

Let's do a crude size estimate of the Glottolog data, counting the lines in the file:

```bash
$ wc -l data/languages-and-dialects-geo.csv 
18358 data/languages-and-dialects-geo.csv
```
 

Now we inspect the file using csvkit's `csvstat` command.
In general it is advisable to constrain the amount of guessing csvkit has to do by specifying all we know about a CSV file. For example, [RFC 4180](https://www.ietf.org/rfc/rfc4180.txt) (the de facto specification of CSV) allows only double quote `"` as quote character (to be used in case field content contains a comma or newline).

```bash
$ csvstat -q '"' data/languages-and-dialects-geo.csv
  1. glottocode
	<class 'str'>
	Nulls: False
	Unique values: 18357
	Max length: 8
  2. name
	<class 'str'>
	Nulls: True
	Unique values: 18227
	Max length: 58
  3. isocodes
	<class 'str'>
	Nulls: True
	Unique values: 7361
	Max length: 4
  4. level
	<class 'str'>
	Nulls: False
	Values: language, dialect
  5. macroarea
	<class 'str'>
	Nulls: True
	Unique values: 6
	5 most frequent values:
		Africa:	5911
		Eurasia:	4992
		Papunesia:	4817
		South America:	1041
		North America:	995
	Max length: 13
  6. latitude
	<class 'float'>
	Nulls: True
	Min: -55.2748
	Max: 73.1354
	Mean: 7.874138763516291
	Median: 6.08134
	Standard Deviation: 18.678027079778794
	...
  7. longitude
	<class 'float'>
	Nulls: True
	Min: -178.785
	Max: 179.306
	Sum: 372863.3632390997
	Mean: 50.6539007253226
	Median: 45.152856
	Standard Deviation: 81.61051507133911
    ...

Row count: 18357
```

Notes:
- The row count matches our expectation from counting the lines in the file. (It could be lower, 
  though, because CSV does allow newlines in field content.)
- csvkit also detected plausible data types for the fields; in particular, latitude and longitude
  were detected as containing floating point numbers.
- Running csvstat on the 8.2 MB PHOIBLE file with 75,388 rows takes > 10 secs on a pretty fast
  machine.

## Next section

[Importing CSV data](03-importing-csv.md)
