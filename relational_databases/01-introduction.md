# Introduction

The [software carpentry](http://software-carpentry.org/) lesson on 
[Databases and SQL](http://swcarpentry.github.io/sql-novice-survey/) describes relational
databases as

> a way to store and manipulate information. Databases are arranged as **tables**. Each table 
> has **columns** (also known as **fields**) that describe the data, and **rows** (also known as **records**) 
> which contain the data.

> When we are using a spreadsheet, we put formulas into cells to calculate new values based 
> on old ones. When we are using a database, we send commands (usually called queries) to a 
> **database manager**: a program that manipulates the database for us. The database manager does 
> whatever lookups and calculations the query specifies, returning the results in a tabular 
> form that we can then use as a starting point for further queries.

Using relational databases is motivated as follows:

> Three common options for storage are text files, spreadsheets, and databases. Text files 
> are easiest to create, and work well with version control, but then we would have to build 
> search and analysis tools ourselves. Spreadsheets are good for doing simple analyses, but 
> they don’t handle large or complex data sets well. Databases, however, include powerful 
> tools for search and analysis, and can handle large, complex data sets. These lessons will 
> show how to use a database to explore [...] data.

In addition to handling lots of data well (gigabytes of data or more), relational databases
are also very well suited to store data that is still updated/added to or otherwise curated,
because they provide guaranteed data integrity via
- [ACID](https://en.wikipedia.org/wiki/ACID) transactions,
- constraints (i.e. column or table level rules for the data that can be stored).


## SQL

Again quoting the [software carpentry](http://software-carpentry.org/) lesson:
 
> **Queries** are written in a language called **SQL**, which stands for “Structured Query Language”. 
> SQL provides hundreds of different ways to analyze and recombine data. We will only look at 
> a handful of queries, but that handful accounts for most of what scientists do.

Many standard mechanisms to manipulate data (or at least their common names) have their
origins in the SQL standard, e.g.
- the `groupby` function in python's `itertools` library,
- the `csvjoin` command of csvkit,
- the R data.table package explicitely mentions SQL as a motivation of its syntax.

SQL comprises functionality for
- schema creation and modification: `CREATE|DROP|ALTER TABLE` (the so-called 
  [DDL - data definition language](https://en.wikipedia.org/wiki/Data_definition_language))
- data curation: `INSERT`, `UPDATE` (the so-called
  [DML - data manipulation language](https://en.wikipedia.org/wiki/Data_manipulation_language))
  including data retrieval: [`SELECT`](https://en.wikipedia.org/wiki/Select_%28SQL%29).
- [transaction](https://en.wikipedia.org/wiki/Database_transaction) control: `COMMIT`, `ROLLBACK`

SQL is a large standard, and like most large standards, no implementation adheres to 100% of it.
Still, when sticking to basic constructs, a good level of interoperability between database
platforms can be reached.


## SQLite

While relational database still rather sound like big business, and vendors like oracle
come to mind, this image is not accurate anymore. In particular [SQLite](https://www.sqlite.org/) 
has been a game changer in this respect.

Quoting from the website:

> SQLite is a software library that implements a self-contained, serverless, [...] transactional SQL database engine. 

> SQLite is the most widely deployed database engine in the world.

It's [virtually everywhere](https://www.sqlite.org/famous.html):
- in Firefox, storing browser history, bookmarks, etc.
- in python's standard library as `sqlite3` module.
- in iPods, iPhones, ...

A sqlite database is just one file, in a binary format, but reasonably stable and portable
to also work as data exchange format.


## Next section

[CSV data](02-csv-data.md)
