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
- There are as many distinct values for the `glottocode` field as there are rows, so we can
  safely assume that the file contains one row per distinct languoid.
- csvkit also detected plausible data types for the fields; in particular, latitude and longitude
  were detected as containing floating point numbers.

## The PHOIBLE data

The data from PHOIBLE lists each single phoneme found in any phoneme inventory aggregated by
PHOIBLE. There may be more than one inventories per language. Quoting from the PHOIBLE site:

> The 2014 edition includes 2155 inventories that contain 2160 segment types found in 1672 distinct languages.

From the [PHOIBLE site](http://phoible.org/contributors/UPSID) we also learn that

> UPSID inventories contain no descriptions of tone.

Thus, the inventories from the UCLA Phonological Segment Inventory Database must be ignored 
when analyzing the distribution of tone languages.
(Erroneously including UPSID inventories does have an impact on the analysis as can
be gleaned from 
[this commit](https://github.com/shh-dlce/qmss-2016/commit/7cf7976d92db675d95dac6412c2a80a8edee6137).)


```bash
$ csvstat -t data/phoible-by-phoneme.tsv 
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
- This data file separates values in rows by a tab `\t`, which is a common variant of 
  delimiter-separated values.
- The `LanguageCode` field looks like it holds exactly one ISO 639-3 language identifier.
- UPSID inventories are identified by a value of `upsid` for the `Source` field.
- Running `csvstat` on this 8.2 MB file with 75,388 rows takes > 10 secs on a pretty fast
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

```bash
$ csvstat data/dplace-societies-2016-4-19-clean.csv
  1. Source
	<class 'str'>
	Nulls: False
	Values: Binford Hunter-Gatherer, Ethnographic Atlas
  2. Preferred_society_name
	<class 'str'>
	Nulls: False
	Unique values: 1406
	5 most frequent values:
		Bannock:	2
		Northern Saulteaux:	2
		Coos:	2
		Tongva:	2
		Koso:	2
	Max length: 38
  3. Society_id
	<class 'str'>
	Nulls: False
	Unique values: 1621
	Max length: 5
  4. Cross_dataset_id
	<class 'str'>
	Nulls: False
	Unique values: 1396
	5 most frequent values:
		xd1166:	4
		xd1116:	3
		xd995:	3
		xd1162:	3
		xd1189:	3
	Max length: 6
  5. Original_society_name
	<class 'str'>
	Nulls: False
	Unique values: 1621
	Max length: 42
  6. Revised_latitude
	<class 'float'>
	Nulls: False
	Min: -55.02
	Max: 78.0
	Sum: 28735.86000000001
	Mean: 17.727242442936465
	Median: 12.0
	Standard Deviation: 25.397885862335116
	Unique values: 552
	5 most frequent values:
		6.0:	45
		10.0:	40
		11.0:	39
		36.0:	33
		8.0:	33
  7. Revised_longitude
	<class 'float'>
	Nulls: False
	Min: -179.31
	Max: 178.68
	Sum: -12432.269999999995
	Mean: -7.669506477483032
	Median: 9.0
	Standard Deviation: 91.08959368789903
	Unique values: 696
	5 most frequent values:
		36.0:	29
		34.0:	22
		35.0:	21
		31.0:	20
		28.0:	19
  8. Original_latitude
	<class 'float'>
	Nulls: False
	Min: -60.0
	Max: 78.0
	Sum: 28674.490000000005
	Mean: 17.689383096853796
	Median: 12.0
	Standard Deviation: 25.431918851577553
	Unique values: 407
	5 most frequent values:
		6.0:	47
		10.0:	43
		11.0:	40
		7.0:	39
		12.0:	34
  9. Original_longitude
	<class 'float'>
	Nulls: False
	Min: -190.0
	Max: 179.0
	Sum: -12107.100000000019
	Mean: -7.468908081431227
	Median: 9.0
	Standard Deviation: 91.18568419752538
	Unique values: 581
	5 most frequent values:
		36.0:	29
		35.0:	23
		34.0:	22
		31.0:	20
		28.0:	20
 10. glottocode
	<class 'str'>
	Nulls: True
	Unique values: 1303
	5 most frequent values:
		west2622:	20
		utee1244:	14
		nort2955:	10
		mono1275:	8
		nort1551:	8
	Max length: 8
 11. Glottolog_name
	<class 'str'>
	Nulls: True
	Unique values: 1303
	5 most frequent values:
		Western Shoshoni:	20
		Ute:	14
		Northern Shoshoni:	10
		Mono (USA):	8
		North Northern Paiute:	8
	Max length: 43
 12. ISO_code
	<class 'str'>
	Nulls: True
	Unique values: 1095
	5 most frequent values:
		mnr:	8
		par:	7
		mey:	6
		crj:	5
		yuk:	5
	Max length: 4
 13. Language_family
	<class 'str'>
	Nulls: True
	Unique values: 182
	5 most frequent values:
		Atlantic-Congo:	314
		Austronesian:	133
		Uto-Aztecan:	111
		Afro-Asiatic:	103
		Athapaskan-Eyak-Tlingit:	64
	Max length: 24
 14. Precipitation
	<class 'float'>
	Nulls: False
	Min: 1.115166667
	Max: 547.9481667
	Sum: 158746.87566653092
	Mean: 97.93144704906287
	Median: 82.39916667
	Standard Deviation: 75.03330218761879
	Unique values: 1397
	5 most frequent values:
		81.08633333:	6
		102.6308333:	6
		72.78:	5
		93.93233333:	5
		179.131:	5
 15. Comment_Monthly_Mean_Precipitation
	<class 'str'>
	Nulls: True
	Unique values: 31
	Max length: 127

Row count: 1621
```

Notes:
- `Society_id` is a unique field, thus, the dataset lists one row per distinct society.
- `glottocode` is not unique, though. So multiple societies may share the same `glottocode` value.


## Next section

[Importing CSV data](03-importing-csv.md)
