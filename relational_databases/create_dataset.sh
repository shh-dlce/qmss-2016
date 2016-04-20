#!/bin/bash
DB=qmss.sqlite
if [ -e $DB ]
then
    rm $DB
fi
csvsql --db=sqlite:///$DB --insert --tables languoids -q '"' data/languages-and-dialects-geo.csv
csvsql --db=sqlite:///$DB --insert --tables phonemes -t data/phoible-by-phoneme.tsv 
csvsql --db=sqlite:///$DB --insert --tables precipitation data/dplace-societies-2016-4-19-clean.csv
sqlite3 -csv -header $DB "`cat query.sql`" > dataset.csv
