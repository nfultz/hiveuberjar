# hiveuberjar

This is an R client to interact with the [Apache Hive](https://hive.apache.org/) data warehouse, including wrapper functions 
around the [Hive JDBC Uber Jar](https://github.com/timveil/hive-jdbc-uber-jar).

## Installation

![CRAN version](http://www.r-pkg.org/badges/version-ago/hiveuberjar) - Some day this will work

```r
install.packages("hiveuberjar")
```

Or you can easily install the most recent development version of the R package as well:

```r
devtools::install_github('nfultz/hiveuberjar')
```

## What is it good for?

This provides a simplified DBI driver for Hive:

```r
require(DBI)
con <- dbConnect(hiveuberjar::HiveUber(), url="jdbc://host:port/schema")
dbListTables(con)
dbGetQuery(con, "Select *count(*) from nfultz.iris limit 10")
```

Installing and loading the JDBC driver package is handled automatically. Authentication via kerberos is also supported.

## What if I want to do other cool things with Hive and R?

Most database functionality is actually provided by RJDBC, but if you have Hive-specific
features in mind, please open a ticket on the feature request, or even better, submit a pull request :)

## It doesn't work here!

Please open an issue here on github.
