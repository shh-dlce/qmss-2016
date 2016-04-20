# Exporting CSV data

## Using sqlite3

sqlite3 supports export to CSV as follows:

```bash
sqlite> .header on
sqlite> .mode csv
sqlite> .output dataset.csv
sqlite> SELECT * FROM dataset;
sqlite> .output stdout
```

## Using SQLite Manager

Choose
> View -> Export View

![SQLite Manager export](images/sqlitemanager-export.png)

Configure the export, click "OK", select an output file and enjoy!


## Next section

[What's next?](06-whats-next.md)
