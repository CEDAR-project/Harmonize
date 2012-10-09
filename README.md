Harmonize
=========

Prototype for harmonizing RDF census data using variable, occupation and municipality mappings

## Introduction

The census has a lot of non-homogeneous entities, like names of occupations and municipalities, due to the long time frame in which it was generated. All these data has to be conveniently harmonized (i.e. explicitly state what names are related to the same abstract entity across time).

One possible way for achieving this is to use external classification systems. These systems classify entities like occupations and municipalities in one single, consistent classification that takes into account all labels and meaning shifts across years.

Harmonize converts the existing [HISCO](http://historyofwork.iisg.nl/) (History of Work Information System) and AC (Amsterdam Code) into RDF and links non-homogeneous labels of occupations and municipalities with these codes. It also harmonizes variable names with manual mappings.

## How does it work

The script has a two-phase workflow for each of the three non-homogeneous artifacts (occupations, municipalities and variables):

* First, it reads an external file which typically assigns an identifier with all its possible values (e.g. a occupation code with all occupation labels related to that code), and generates an RDF graph representing that information. In the variable case a direct mapping file is translated ('etc/variable-mappings.csv'); HISCO and AC are read from Excel workbooks ('etc/HISCO.xls' and 'etc/AC.xls').

* Second, it queries a triplestore through a local SPARQL endpoint to link non-homogeneous representations of those variables, occupations and municipalities to the previously generated identifiers. In the variable case the direct mapping file is enough; for the HISCO and AC a string similarity measure is used.

### Input files

All are located in the 'etc' directory.

### Output files

A single harmonize.ttl RDF file with the triplified version of the classification systems and the mappings.

## Requirements

* Python 2.7.3
* xlrd, rdflib, SPARQLWrapper, Levenshtein, csv libraries
* Local SPARQL endpoint with some census data triples loaded
