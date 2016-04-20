# Know your data

As we will realize repeatedly during this tutorial it is essential to have
a good understanding of the data one is dealing with.

We downloaded 
- a CSV file containing data about languages and dialects from Glottolog,
- a TSV file containing the PHOIBLE database on phoneme inventories and 
- a CSV file listing values for monthly mean precipitation from D-PLACE.

See [README](data/README.md) for details.


## The Glottolog data

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
- There are as many distinct values for the `glottocode` field as there rows, so we can
  safely assume that the file contains one row per distinct languoid.
- csvkit also detected plausible data types for the fields; in particular, latitude and longitude
  were detected as containing floating point numbers.

## The PHOIBLE data

The data from PHOIBLE lists each single phoneme found in any phoneme inventory aggregated by
PHOIBLE. There may be more than one inventories per language. Quoting from the PHOIBLE site:

> The 2014 edition includes 2155 inventories that contain 2160 segment types found in 1672 distinct languages.

Note that this data file separates values in rows by a tab `\t`, which is a common variant of 
delimiter-separated values.

http://phoible.org/contributors/UPSID

> UPSID inventories contain no descriptions of tone.

http://phoible.org/inventories?sSearch_6=UCLA%20Phonological%20Segment%20Inventory%20Database

```
(qmss2016)dlt5502178l:~/venvs/qmss2016/qmss-2016/relational_databases$ csvstat -t data/phoible-by-phoneme.tsv 
  1. LanguageCode
	<class 'str'>
	Nulls: False
	Unique values: 1672
	5 most frequent values:
		gwn:	323
		nyf:	282
		sgw:	254
		xtc:	245
		hin:	213
	Max length: 3
  2. LanguageName
	<class 'str'>
	Nulls: False
        ...
  3. SpecificDialect
        ...
  4. Phoneme
	<class 'str'>
	Nulls: False
	Unique values: 2215
	5 most frequent values:
		m:	2053
		k:	2016
		i:	1998
		a:	1961
		j:	1901
	Max length: 11
  5. Allophones
        ...
  6. Source
	<class 'str'>
	Nulls: False
	Unique values: 7
	5 most frequent values:
		gm:	19280
		upsid:	13966
		ph:	13260
		saphon:	9051
		aa:	8064
	Max length: 6
  7. GlyphID
        ...
  8. InventoryID
	<class 'int'>
	Nulls: False
  9. tone
	<class 'str'>
	Nulls: True
	Values: +, 0
 10. stress
        ...
 45. click
        ...

Row count: 75388
```

Notes:
- The `LanguageCode` field looks like it holds exactly one ISO 639-3 language identifier.
- UPSID inventories are identified by a value of `upsid` for the `Source` field.
- Running csvstat on the 8.2 MB PHOIBLE file with 75,388 rows takes > 10 secs on a pretty fast
  machine.


## The D-PLACE data

The D-PLACE data showcases a shortcoming of the CSV format: There is no standard or straightforward
way of associating metadata with the data. One way to handle this is by packaging the data file with
a metadata file using a container format like `zip` 
(see for example the [WALS dataset](http://wals.info/static/download/wals-language.csv.zip)).
Alternatively, metadata can be included in the data file, which unfortunately forces some preprocessing.

D-PLACE has chosen the latter alternative, as can be seen by taking a peek at the data:

```bash
$ head -n 3 data/dplace-societies-2016-4-19.csv 
"Research that uses data from D-PLACE should cite both the original source(s) of  the data and the paper by Kirby et al. in which D-PLACE was first presented  (e.g., research using cultural data from the Binford Hunter-Gatherer dataset: ""Binford (2001);  Binford and Johnson (2006); Kirby et al. Submitted)."" The reference list should include the date data were  accessed and URL for D-PLACE (http://d-place.org), in addition to the full references for Binford (2001),  Binford and Johnson (2006), and Kirby et al. Submitted."
Source,Preferred society name,Society id,Cross-dataset id,Original society name,Revised latitude,Revised longitude,Original latitude,Original longitude,Glottolog language/dialect id,Glottolog language/dialect name,ISO code,Language family,Variable: Monthly Mean Precipitation (mm),Comment: Monthly Mean Precipitation (mm)
Ethnographic Atlas,!Kung,Aa1,xd1,Kung (Aa1),-20.0,21.0,-20.0,21.0,juho1239,Ju'hoan,ktz,Kxa,33.978,
```

A preprocessed version of the file, with citation notice removed and whitespace in column 
names replaced is available [in the repository](data/dplace-societies-2016-4-19-clean.csv).


## Next section

[Importing CSV data](03-importing-csv.md)
