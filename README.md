
`ndjson`
========

Wicked-fast Streaming JSON ('ndjson') Reader

Description
-----------

Rcpp/C++11 wrapper for <https://github.com/nlohmann/json>

The goal is to create a completely "flat" `data.frame`-like structure from ndjson records in plain text ndjson files or gzip'd ndjson files.

### Installation guidance for Linux/BSD-ish systems

CRAN has binaries for Windows and macOS. To build this on UNIX-like systems, you need at least g++4.9 or clang++. This is a forced requirement by the ndjson library.

The least painful way to do this is to install gcc &gt;= 4.9 (and you should install ccache while you're at it) and mmodfiy `~/.R/Makevars` thusly:

    # Use whatever version of (g++ >=4.9 or clang++) that you downloaded
    VER=-4.9
    CC=ccache gcc$(VER)
    CXX=ccache g++$(VER)
    SHLIB_CXXLD=g++$(VER)
    FC=ccache gfortran
    F77=ccache gfortran

Why `ndjson` + Examples
-----------------------

An example of such files are the output from Rapid7 internet-wide scans, such as their [HTTPS study](https://scans.io/study/sonar.https). A gzip'd extract of 100,000 of one of those scans weighs in abt about 171MB. The records sometimes contain heavily nested JSON elements depending on how comprehensive the certificate data and other fields were. A typical record will look like this:

    {
      "vhost": "teamchat.buzzpoints.com",
      "host": "52.87.143.83",
      "certsubject": {
        "CN": "teamchat.buzzpoints.com"
      },
      "ip": "52.87.143.83",
      "data": "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",
      "port": "443"
    }

A `system.time(df <- stream_in("https-extract.json.gz"))` results in:

       user  system elapsed 
     14.822   0.224  15.189 

on a 13" MacBook Pro and produces:

    Classes ‘tbl_dt’, ‘tbl’, ‘data.table’ and 'data.frame': 100000 obs. of  36 variables:
     $ certsubject.CN                 : chr  "*.tio.ch" "*.starwoodhotels.com" "a.ssl.fastly.net" "a.ssl.fastly.net" ...
     $ data                           : chr  "SFRUUC8xLjEgNDAzIEZvcmJpZGRlbg0KU2VydmVyOiBjbG91ZGZsYXJlLW5naW54DQpEYXRlOiBNb24sIDIyIEF1ZyAyMDE2IDE3OjE2OjE2IEdNVA0KQ29udGVudC1"| __truncated__ "SFRUUC8xLjAgNDAwIEJhZCBSZXF1ZXN0DQpTZXJ2ZXI6IEFrYW1haUdIb3N0DQpNaW1lLVZlcnNpb246IDEuMA0KQ29udGVudC1UeXBlOiB0ZXh0L2h0bWwNCkNvbnR"| __truncated__ "SFRUUC8xLjEgNTAwIERvbWFpbiBOb3QgRm91bmQNClNlcnZlcjogVmFybmlzaA0KUmV0cnktQWZ0ZXI6IDANCmNvbnRlbnQtdHlwZTogdGV4dC9odG1sDQpDYWNoZS1"| __truncated__ "SFRUUC8xLjEgNTAwIERvbWFpbiBOb3QgRm91bmQNClNlcnZlcjogVmFybmlzaA0KUmV0cnktQWZ0ZXI6IDANCmNvbnRlbnQtdHlwZTogdGV4dC9odG1sDQpDYWNoZS1"| __truncated__ ...
     $ host                           : chr  "104.20.28.6" "104.80.186.186" "151.101.255.54" "151.101.158.15" ...
     $ ip                             : chr  "104.20.28.6" "104.80.186.186" "151.101.255.54" "151.101.158.15" ...
     $ port                           : chr  "443" "443" "443" "443" ...
     $ vhost                          : chr  "104.20.28.6" "104.80.186.186" "a.ssl.fastly.net" "a.ssl.fastly.net" ...
     $ certsubject.C                  : chr  NA "US" "US" "US" ...
     $ certsubject.L                  : chr  NA "Stamford" "San Francisco" "San Francisco" ...
     $ certsubject.O                  : chr  NA "STARWOOD HOTELS AND RESORTS WORLDWIDE, INC." "Fastly, Inc." "Fastly, Inc." ...
     $ certsubject.OU                 : chr  NA "IT Solutions" NA NA ...
     $ certsubject.ST                 : chr  NA "Connecticut" "California" "California" ...
     $ certsubject.emailAddress       : chr  NA NA NA NA ...
     $ certsubject.UNDEF              : chr  NA NA NA NA ...
     $ certsubject.businessCategory   : chr  NA NA NA NA ...
     $ certsubject.postalCode         : chr  NA NA NA NA ...
     $ certsubject.serialNumber       : chr  NA NA NA NA ...
     $ certsubject.street             : chr  NA NA NA NA ...
     $ certsubject.SN                 : chr  NA NA NA NA ...
     $ certsubject.unstructuredName   : chr  NA NA NA NA ...
     $ certsubject.ITU-T              : chr  NA NA NA NA ...
     $ certsubject.GN                 : chr  NA NA NA NA ...
     $ certsubject.description        : chr  NA NA NA NA ...
     $ certsubject.subjectAltName     : chr  NA NA NA NA ...
     $ certsubject.name               : chr  NA NA NA NA ...
     $ certsubject.DC                 : chr  NA NA NA NA ...
     $ certsubject.postOfficeBox      : chr  NA NA NA NA ...
     $ certsubject.dnQualifier        : chr  NA NA NA NA ...
     $ certsubject.generationQualifier: chr  NA NA NA NA ...
     $ certsubject.initials           : chr  NA NA NA NA ...
     $ certsubject.pseudonym          : chr  NA NA NA NA ...
     $ certsubject.title              : chr  NA NA NA NA ...
     $ certsubject                    : int  NA NA NA NA NA NA NA NA NA NA ...
     $ certsubject.unstructuredAddress: chr  NA NA NA NA ...
     $ certsubject.UID                : chr  NA NA NA NA ...
     $ certsubject.mail               : chr  NA NA NA NA ...
     $ certsubject.Mail               : chr  NA NA NA NA ...
     - attr(*, ".internal.selfref")=<externalptr> 

All of the certificate sub-field data elents have been expanded and we have a highly performant `tbl_dt` to work with now either in `dplyr` syntax or `data.table` heiroglyphic syntax. Just go see what you have to do in `jsonlite` to get a similar output (and how long it will take).

`pryr::object_size(df)` for that shows it's consuming `394 MB`, which means we can read in many more extracts comfortably on a reasonably configured system and most (if not all) of it on a well-configured AWS box.

However, if you do end up trying to work with that scan data, it's highly recommended that you use `jq` to filter out the fields or records you want into a more compact ndjson file.

What's inside the tin?
----------------------

The following functions are implemented:

-   `stream_in`: Stream in ndjson from a file (handles `.gz` files)
-   `validate`: Validate JSON records in an ndjson file (handles `.gz` files)
-   `flatten`: Flatten a character vector of individual JSON lines

There are no current plans for a `stream_out()` function since `jsonlite::stream_out()` does a great job tossing `data.frame`-like structures out to an ndjson file.

Installation
------------

``` r
devtools::install_git("https://gitlab.com/hrbrmstr/ndjson.git")
```

Usage
-----

``` r
library(ndjson)
library(microbenchmark)

# current verison
packageVersion("ndjson")
```

    ## [1] '0.7.0'

``` r
flatten('{"top":{"next":{"final":1,"end":true},"another":"yes"},"more":"no"}')

f <- system.file("extdata", "test.json", package="ndjson")
gzf <- system.file("extdata", "testgz.json.gz", package="ndjson")

head(ndjson::stream_in(f))
```

    ##    args headers.Accept headers.Accept-Encoding headers.Host       headers.User-Agent id        origin
    ## 1:   NA            */*                identity  httpbin.org Wget/1.18 (darwin15.5.0)  0 50.252.233.22
    ## 2:   NA            */*                identity  httpbin.org Wget/1.18 (darwin15.5.0)  1 50.252.233.22
    ## 3:   NA            */*                identity  httpbin.org Wget/1.18 (darwin15.5.0)  2 50.252.233.22
    ## 4:   NA            */*                identity  httpbin.org Wget/1.18 (darwin15.5.0)  3 50.252.233.22
    ## 5:   NA            */*                identity  httpbin.org Wget/1.18 (darwin15.5.0)  4 50.252.233.22
    ## 6:   NA            */*                identity  httpbin.org Wget/1.18 (darwin15.5.0)  5 50.252.233.22
    ##                              url
    ## 1: http://httpbin.org/stream/100
    ## 2: http://httpbin.org/stream/100
    ## 3: http://httpbin.org/stream/100
    ## 4: http://httpbin.org/stream/100
    ## 5: http://httpbin.org/stream/100
    ## 6: http://httpbin.org/stream/100

``` r
head(ndjson::stream_in(gzf))
```

    ##    args headers.Accept headers.Accept-Encoding headers.Host       headers.User-Agent id        origin
    ## 1:   NA            */*                identity  httpbin.org Wget/1.18 (darwin15.5.0)  0 50.252.233.22
    ## 2:   NA            */*                identity  httpbin.org Wget/1.18 (darwin15.5.0)  1 50.252.233.22
    ## 3:   NA            */*                identity  httpbin.org Wget/1.18 (darwin15.5.0)  2 50.252.233.22
    ## 4:   NA            */*                identity  httpbin.org Wget/1.18 (darwin15.5.0)  3 50.252.233.22
    ## 5:   NA            */*                identity  httpbin.org Wget/1.18 (darwin15.5.0)  4 50.252.233.22
    ## 6:   NA            */*                identity  httpbin.org Wget/1.18 (darwin15.5.0)  5 50.252.233.22
    ##                              url
    ## 1: http://httpbin.org/stream/100
    ## 2: http://httpbin.org/stream/100
    ## 3: http://httpbin.org/stream/100
    ## 4: http://httpbin.org/stream/100
    ## 5: http://httpbin.org/stream/100
    ## 6: http://httpbin.org/stream/100

``` r
head(jsonlite::stream_in(file(f), flatten=TRUE, verbose=FALSE))
```

    ##                             url id        origin headers.Host headers.Accept-Encoding headers.Accept
    ## 1 http://httpbin.org/stream/100  0 50.252.233.22  httpbin.org                identity            */*
    ## 2 http://httpbin.org/stream/100  1 50.252.233.22  httpbin.org                identity            */*
    ## 3 http://httpbin.org/stream/100  2 50.252.233.22  httpbin.org                identity            */*
    ## 4 http://httpbin.org/stream/100  3 50.252.233.22  httpbin.org                identity            */*
    ## 5 http://httpbin.org/stream/100  4 50.252.233.22  httpbin.org                identity            */*
    ## 6 http://httpbin.org/stream/100  5 50.252.233.22  httpbin.org                identity            */*
    ##         headers.User-Agent
    ## 1 Wget/1.18 (darwin15.5.0)
    ## 2 Wget/1.18 (darwin15.5.0)
    ## 3 Wget/1.18 (darwin15.5.0)
    ## 4 Wget/1.18 (darwin15.5.0)
    ## 5 Wget/1.18 (darwin15.5.0)
    ## 6 Wget/1.18 (darwin15.5.0)

``` r
head(jsonlite::stream_in(gzfile(gzf), flatten=TRUE, verbose=FALSE))
```

    ##                             url id        origin headers.Host headers.Accept-Encoding headers.Accept
    ## 1 http://httpbin.org/stream/100  0 50.252.233.22  httpbin.org                identity            */*
    ## 2 http://httpbin.org/stream/100  1 50.252.233.22  httpbin.org                identity            */*
    ## 3 http://httpbin.org/stream/100  2 50.252.233.22  httpbin.org                identity            */*
    ## 4 http://httpbin.org/stream/100  3 50.252.233.22  httpbin.org                identity            */*
    ## 5 http://httpbin.org/stream/100  4 50.252.233.22  httpbin.org                identity            */*
    ## 6 http://httpbin.org/stream/100  5 50.252.233.22  httpbin.org                identity            */*
    ##         headers.User-Agent
    ## 1 Wget/1.18 (darwin15.5.0)
    ## 2 Wget/1.18 (darwin15.5.0)
    ## 3 Wget/1.18 (darwin15.5.0)
    ## 4 Wget/1.18 (darwin15.5.0)
    ## 5 Wget/1.18 (darwin15.5.0)
    ## 6 Wget/1.18 (darwin15.5.0)

``` r
microbenchmark(
    ndjson={ ndjson::stream_in(f) },
  jsonlite={ jsonlite::stream_in(file(f), flatten=TRUE, verbose=FALSE) }
)
```

    ## Unit: milliseconds
    ##      expr      min       lq     mean   median       uq      max neval
    ##    ndjson 2.047605 2.148976 2.343607 2.229443 2.382465 5.570769   100
    ##  jsonlite 4.226825 4.372241 4.581094 4.458739 4.737780 8.001440   100

``` r
microbenchmark(
    ndjson={ ndjson::stream_in(gzf) },
  jsonlite={ jsonlite::stream_in(gzfile(gzf), flatten=TRUE, verbose=FALSE) }
)
```

    ## Unit: milliseconds
    ##      expr      min       lq     mean   median       uq      max neval
    ##    ndjson 1.966285 2.056864 2.194036 2.102801 2.211017 2.982188   100
    ##  jsonlite 3.534121 3.594526 3.779181 3.646757 3.755273 7.990776   100

Test Results
------------

``` r
library(ndjson)
library(testthat)

date()
```

    ## [1] "Wed Mar  6 22:08:24 2019"

``` r
test_dir("tests/")
```

    ## ✔ | OK F W S | Context
    ## ══ testthat results  ══════════════════════════════════════════════════════════════════════════════════════
    ## OK: 6 SKIPPED: 0 FAILED: 0
    ## 
    ## ══ Results ════════════════════════════════════════════════════════════════════════════════════════════════
    ## Duration: 0.2 s
    ## 
    ## OK:       0
    ## Failed:   0
    ## Warnings: 0
    ## Skipped:  0

Code of Conduct
---------------

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
