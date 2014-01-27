#!/usr/bin/python

# harmonization.py
# Converts Amsterdam Code (AC) to RDF (naively) and links AC URIs to TabLinker Gemeente URIs
# by means of minimum Levenshtein distance between literals representing both
# AC should get its own namespace (i.e. working domain name)
# Converts HISCO to RDF (naively) and links HISCO URIs to TabLinker profession URIs
# Produces triples mapping all variable names into a generic one

from xlrd import open_workbook
from rdflib import ConjunctiveGraph, Namespace, Literal, RDF, RDFS, BNode, URIRef
from SPARQLWrapper import SPARQLWrapper, JSON, POST
from Levenshtein import ratio
import csv

# 0. Generate RDF graph from AC tabular data
acBook = open_workbook('etc/AC.xls', formatting_info=True)
acSheet = acBook.sheet_by_index(0)

namespaces = {
    'd2s':Namespace('http://www.data2semantics.org/data/'),
    'cpm':Namespace('http://cedar-project.nl/harmonization/municipalities/'),
    'cpv':Namespace('http://cedar-project.nl/harmonization/variables/'),
    'cpo':Namespace('http://cedar-project.nl/harmonization/occupations/'),
    'skos':Namespace('http://www.w3.org/2004/02/skos/core#'), 
}

graph = ConjunctiveGraph()
for namespace in namespaces:
    graph.namespace_manager.bind(namespace, namespaces[namespace])

## Cols to read: [1,5] Rows to read: [2:1829]
acCodes = []
for i in range(2,1830):
    graph.add((
            namespaces['cpm'][str(int(acSheet.cell(i,1).value))],
            RDF.type,
            namespaces['cpm']['AmsterdamCodeMunicipality']
            ))
    graph.add((
            namespaces['cpm'][str(int(acSheet.cell(i,1).value))],
            namespaces['cpm']['hasAmsterdamCode'],
            Literal(int(acSheet.cell(i,1).value))
            ))
    graph.add((
            namespaces['cpm'][str(int(acSheet.cell(i,1).value))],
            namespaces['skos']['prefLabel'],
            Literal(acSheet.cell(i,5).value)
            ))

    # Local data structure
    acCode = {}
    acCode["code"] = str(int(acSheet.cell(i,1).value))
    acCode["label"] = acSheet.cell(i,5).value
    acCodes.append(acCode)

# 1. Retrieve current Gemeente URIs through SPARQL
sparql = SPARQLWrapper('http://localhost:8890/sparql')

query = """
    PREFIX d2s: <http://www.data2semantics.org/data/VT_1859_01_H1_marked/> 
    PREFIX ns1: <http://www.data2semantics.org/data/VT_1859_01_H1_marked/NOORDBRABANT/> 
    PREFIX qb: <http://purl.org/linked-data/cube#>
    PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

    SELECT ?municipalityURI ?municipalityLabel WHERE {
        ?municipalityURI qb:dataSet d2s:NOORDBRABANT .
        ?municipalityURI skos:broader ns1:NOORDBRABANT_ .
        ?municipalityURI skos:prefLabel ?municipalityLabel
    }
    """

sparql.setQuery(query)
sparql.setReturnFormat(JSON)
results = sparql.query().convert()

municipalities = []
for result in results["results"]["bindings"]:
    municipality = {}
    municipality["uri"] = URIRef(result["municipalityURI"]["value"])
    municipality["label"] = result["municipalityLabel"]["value"]
    municipalities.append(municipality)

# 2. Compute Levenshtein distances between all literal Gemeente URIs and literal AC URIs
for municipality in municipalities:
    max_r = 0
    moreAlike = acCodes[0]["code"]
    for code in acCodes:
        r = ratio(municipality["label"].encode('utf8'), code["label"].encode('utf8'))
        if r > max_r:
            max_r = r
            moreAlike = code["code"]
    municipality["code"] = moreAlike

print municipalities            

# 3. Maximum score gets a connecting triple!
for municipality in municipalities:
    graph.add((
            namespaces['cpm'][municipality["code"]],
            namespaces['cpm']['encodesMunicipality'],
            URIRef(municipality["uri"])
            ))

# ----------------------------------------------

# We do all the same for HISCO
hiBook = open_workbook('etc/HISCO.xls', formatting_info=True)
hiSheet = hiBook.sheet_by_index(0)

## Cols to read: [0,1] Rows to read: [2:53216]
hiCodes = []
for i in range(1,53216):
    print i
    graph.add((
            namespaces['cpo'][str(hiSheet.cell(i,1).value)],
            RDF.type,
            namespaces['cpo']['HISCOOccupation']
            ))
    graph.add((
            namespaces['cpo'][str(hiSheet.cell(i,1).value)],
            namespaces['cpo']['hasHISCOCode'],
            Literal(hiSheet.cell(i,1).value)
            ))
    graph.add((
            namespaces['cpo'][str(hiSheet.cell(i,1).value)],
            namespaces['skos']['prefLabel'],
            Literal(hiSheet.cell(i,0).value)
            ))

    # Local data structure
    hiCode = {}
    hiCode["code"] = str(hiSheet.cell(i,1).value)
    hiCode["label"] = hiSheet.cell(i,0).value
    hiCodes.append(hiCode)

# 1. Retrieve current Gemeente URIs through SPARQL
sparql = SPARQLWrapper('http://localhost:8890/sparql')

query = """
    PREFIX d2s: <http://www.data2semantics.org/core/> 
    PREFIX qb: <http://purl.org/linked-data/cube#>
    PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

    SELECT ?occupationURI ?occupationLabel WHERE {
        ?occupationURI qb:dataSet ?dataset .
        ?occupationURI skos:broader ?broader .
        ?occupationURI skos:prefLabel ?occupationLabel .
    }
    """

sparql.setQuery(query)
sparql.setReturnFormat(JSON)
results = sparql.query().convert()

occupations = []
for result in results["results"]["bindings"]:
    occupation = {}
    if result["occupationURI"]["value"].split('_')[1] == '1899':
        occupation["uri"] = URIRef(result["occupationURI"]["value"])
        occupation["label"] = result["occupationLabel"]["value"]
        occupations.append(occupation)

# 2. Compute Levenshtein distances between all literal occupation URIs and literal HISCO URIs

for occupation in occupations:
    max_r = 0
    moreAlike = hiCodes[0]["code"]
    for code in hiCodes:
        r = ratio(occupation["label"].encode('utf8'), code["label"].encode('utf8'))
        if r > max_r:
            max_r = r
            moreAlike = code["code"]
    occupation["code"] = moreAlike

print occupations

# 3. Maximum score gets a connecting triple!
for occupation in occupations:
    graph.add((
            namespaces['cpo'][occupation["code"]],
            namespaces['cpo']['encodesOccupation'],
            URIRef(occupation["uri"])
            ))

# ----------------------------------------------

# Now we harmonize variables according to our mapping CVS
mappings = csv.reader(open('etc/variable-mappings.csv', 'rb'), delimiter=',', quotechar='"')
for variable in mappings:
    # Query to obtain URIs of variables
    sparql = SPARQLWrapper('http://localhost:8890/sparql')

    filterString = '"' + '"@nl,"'.join(variable[1:-1]) + '"'

    query = """
        PREFIX qb: <http://purl.org/linked-data/cube#>
        PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

        SELECT ?variableURI ?variableLabel WHERE {
            ?variableURI a qb:DimensionProperty .
            ?variableURI skos:prefLabel ?variableLabel .
            FILTER (?variableLabel IN (""" + filterString + """))
            
        }
    """

    sparql.setQuery(query)
    sparql.setReturnFormat(JSON)
    results = sparql.query().convert()

    # Create harmonization triples for this variables
    for result in results["results"]["bindings"]:
        graph.add((
                namespaces['cpv'][variable[0]],
                namespaces['cpv']['encodesVariable'],
                URIRef(result["variableURI"]["value"])
                ))
    
# Serialize
fileWrite = open('harmonize.ttl', "w")
turtle = graph.serialize(None, format='n3')
fileWrite.writelines(turtle)
fileWrite.close()
