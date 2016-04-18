# Exporting CSV data

## Using sqlite3

sqlite3 supports export to CSV as follows:

```bash
sqlite> .header on
sqlite> .mode csv
sqlite> .output macroareas.csv
sqlite> select macroarea, count(glottocode) as c from languoids where level = 'language' group by macroarea order by c desc;
sqlite> .output stdout
```

## Using SQLite Manager

To export the results of a query with SQLite Manager we can again make use of a `VIEW`:

> View -> Create View

![SQLite Manager](images/sqlitemanager-create-view-tone_languages_by_macroarea.png)

Then 

> View -> Export View

![SQLite Manager export](images/sqlitemanager-export.png)

Configure the export, click "OK", select an output file and enjoy!

