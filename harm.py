from bottle import route, run, template, request, static_file
from SPARQLWrapper import SPARQLWrapper, JSON
import urllib
import logging
import glob
import sys
import traceback
import os

__VERSION = 0.1

@route('/harmonize/version')
def version():
    return "Harmonize version " + str(__VERSION)

@route('/harmonize')
@route('/harmonize/')
def harmonize():
    return template('harm')

@route('/harmonize/vocab')
def vocab():
    sparql = SPARQLWrapper("http://lod.cedar-project.nl:8080/sparql/cedar")
    sparql.setQuery("""
    PREFIX sdmx: <http://purl.org/linked-data/sdmx#>
    PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
    PREFIX qb: <http://purl.org/linked-data/cube#>
    SELECT ?dimension ?concept ?range ?codelist ?code
    FROM <http://lod.cedar-project.nl/resource/harmonization>
    WHERE {
    ?dimension a qb:DimensionProperty ;
    qb:concept ?concept ;
    rdfs:range ?range .
    OPTIONAL {?dimension qb:codeList ?codelist .
    ?codelist skos:hasTopConcept ?code . }
    } GROUP BY ?dimension ORDER BY ?dimension
    """)
    sparql.setReturnFormat(JSON)
    results = sparql.query().convert()
    return template('vocab', results=results)

@route('/harmonize/harm')
def harm(__ds = None):
    ds = None
    if __ds:
        ds = __ds
    else:
        ds = request.query.ds
    if not ds:
        sparql = SPARQLWrapper("http://lod.cedar-project.nl:8080/sparql/cedar")
        sparql.setQuery("""
        PREFIX d2s: <http://www.data2semantics.org/core/>
        PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
        SELECT ?g ?ltitle
        FROM <http://lod.cedar-project.nl/resource/cedar-dataset>
        WHERE {
        GRAPH ?g {
        ?title a d2s:Title .
        ?title d2s:value ?vtitle .
        ?vtitle skos:prefLabel ?ltitle . 
        }
        } GROUP BY ?g ORDER BY ?g
        """)
        sparql.setReturnFormat(JSON)
        results = sparql.query().convert()
        return template('manage', state='manage-ds', files=results)
    else:
        # List of dimensions, variables and values in the harm layer
        sparql = SPARQLWrapper("http://lod.cedar-project.nl:8080/sparql/cedar")
        sparql.setQuery("""
        PREFIX d2s: <http://www.data2semantics.org/core/>
        PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
        SELECT DISTINCT(?dim) ?ldim ?var ?val
        FROM <%s>
        FROM <http://lod.cedar-project.nl/resource/harm>
        WHERE {
        {GRAPH <%s> {
        ?s d2s:dimension ?dim .
        ?dim skos:prefLabel ?ldim .
        }}
        OPTIONAL {
        {GRAPH <http://lod.cedar-project.nl/resource/harm> {?dim ?var ?val .}}
        }
        } ORDER BY ?ldim
        """ % (ds, ds))
        sparql.setReturnFormat(JSON)
        dimvarval = sparql.query().convert()
        # List of all dimensions (feeding the combos)
        sparql.setQuery("""
        PREFIX sdmx: <http://purl.org/linked-data/sdmx#>
        PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
        PREFIX qb: <http://purl.org/linked-data/cube#>
        SELECT DISTINCT ?dimensionu ?dimension 
        FROM <http://lod.cedar-project.nl/resource/harmonization>
        WHERE {
        ?dimensionu a qb:DimensionProperty ;
        qb:concept ?concept ;
        rdfs:label ?dimension ;
        rdfs:range ?range .
        OPTIONAL {?dimensionu qb:codeList ?codelist .
        ?codelist skos:hasTopConcept ?code . }
        } ORDER BY ?dimension
        """)
        variables = sparql.query().convert()
        # List of all codes (feeding the combos)
        sparql.setQuery("""
        PREFIX sdmx: <http://purl.org/linked-data/sdmx#>
        PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
        PREFIX qb: <http://purl.org/linked-data/cube#>
        SELECT DISTINCT ?codeu ?code
        FROM <http://lod.cedar-project.nl/resource/harmonization>
        WHERE {
        ?dimension a qb:DimensionProperty ;
        qb:concept ?concept ;
        rdfs:range ?range .
        OPTIONAL {?dimension qb:codeList ?codelist .
        ?codelist skos:hasTopConcept ?codeu .
        ?codeu skos:prefLabel ?code . }
        } ORDER BY ?code
        """)
        values = sparql.query().convert()
        return template('manage', state='manage-variables', dimvarval=dimvarval, variables=variables, values=values, ds=ds)

@route('/harmonize/update', method = 'POST')
def update():
    dimension = request.forms.get("dim")
    variable = request.forms.get("ddVariable")
    value = request.forms.get("ddValue")
    ds = request.forms.get("ds")
    print dimension, variable, value, ds
    sparql = SPARQLWrapper("http://lod.cedar-project.nl:8080/sparql/cedar")
    delete = """
    DELETE { GRAPH <http://lod.cedar-project.nl/resource/harm> {<%s> ?var ?val .}}
    WHERE {<%s> ?var ?val .}
    """ % (dimension, dimension)
    sparql.setQuery(delete)
    deleteResults = sparql.query().convert()
    if not (variable == 'None' or value == 'None'):
        insert = """
        INSERT INTO <http://lod.cedar-project.nl/resource/harm> {<%s> <%s> <%s>}
        """ % (dimension, variable, value)
        sparql.setQuery(insert)
        insertResults = sparql.query().convert()
    return harm(ds)

@route('/harmonize/query-iface')
def query_iface():
    sparql = SPARQLWrapper("http://lod.cedar-project.nl:8080/sparql/cedar")
    sparql.setReturnFormat(JSON)    
    # List of all dimensions (feeding the combos)
    sparql.setQuery("""
    PREFIX sdmx: <http://purl.org/linked-data/sdmx#>
    PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
    PREFIX qb: <http://purl.org/linked-data/cube#>
    SELECT DISTINCT ?dimensionu ?dimension 
    FROM <http://lod.cedar-project.nl/resource/harmonization>
    WHERE {
    ?dimensionu a qb:DimensionProperty ;
    qb:concept ?concept ;
    rdfs:label ?dimension ;
    rdfs:range ?range .
    OPTIONAL {?dimensionu qb:codeList ?codelist .
    ?codelist skos:hasTopConcept ?code . }
    } ORDER BY ?dimension
    """)
    variables = sparql.query().convert()
    # List of all codes (feeding the combos)
    sparql.setQuery("""
    PREFIX sdmx: <http://purl.org/linked-data/sdmx#>
    PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
    PREFIX qb: <http://purl.org/linked-data/cube#>
    SELECT DISTINCT ?codeu ?code
    FROM <http://lod.cedar-project.nl/resource/harmonization>
    WHERE {
    ?dimension a qb:DimensionProperty ;
    qb:concept ?concept ;
    rdfs:range ?range .
    OPTIONAL {?dimension qb:codeList ?codelist .
    ?codelist skos:hasTopConcept ?codeu .
    ?codeu skos:prefLabel ?code . }
    } ORDER BY ?code
    """)
    values = sparql.query().convert()
    return template('query', state='start', variables=variables, values=values, prevvar=None, prevval=None, sumcheck=None)

@route('/harmonize/query', method = 'POST')
def query():
    variable = request.forms.get("ddVariable")
    value = request.forms.get("ddValue")
    sumcheck = request.forms.get("sum")
    print variable, value, sumcheck
    sparql = SPARQLWrapper("http://lod.cedar-project.nl:8080/sparql/cedar")
    sparql.setReturnFormat(JSON)
    projections = "?g ?ldim (SUM(?population) AS ?population)" if sumcheck else "?g ?lcell ?ldim ?population"
    query = """
    PREFIX d2s: <http://www.data2semantics.org/core/>
    PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
    SELECT """ + projections + """
    FROM <http://lod.cedar-project.nl/resource/cedar-dataset>
    WHERE {
    GRAPH ?g { ?cell d2s:isObservation [ d2s:dimension ?dim ;
    d2s:populationSize ?population ] .
    ?cell d2s:cell ?lcell .
    { SELECT ?dim FROM <http://lod.cedar-project.nl/resource/harm> WHERE { ?dim <%s> <%s> . } }
    { SELECT ?ldim FROM <http://lod.cedar-project.nl/resource/harmonization> WHERE { <%s> skos:prefLabel ?ldim } }
    }
    } GROUP BY ?g ?ldim ORDER BY ?g
    """ % (variable, value, value)
    print query
    sparql.setQuery(query)
    numbers = sparql.query().convert()
    # List of all dimensions (feeding the combos)
    sparql.setQuery("""
    PREFIX sdmx: <http://purl.org/linked-data/sdmx#>
    PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
    PREFIX qb: <http://purl.org/linked-data/cube#>
    SELECT DISTINCT ?dimensionu ?dimension 
    FROM <http://lod.cedar-project.nl/resource/harmonization>
    WHERE {
    ?dimensionu a qb:DimensionProperty ;
    qb:concept ?concept ;
    rdfs:label ?dimension ;
    rdfs:range ?range .
    OPTIONAL {?dimensionu qb:codeList ?codelist .
    ?codelist skos:hasTopConcept ?code . }
    } ORDER BY ?dimension
    """)
    variables = sparql.query().convert()
    # List of all codes (feeding the combos)
    sparql.setQuery("""
    PREFIX sdmx: <http://purl.org/linked-data/sdmx#>
    PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
    PREFIX qb: <http://purl.org/linked-data/cube#>
    SELECT DISTINCT ?codeu ?code
    FROM <http://lod.cedar-project.nl/resource/harmonization>
    WHERE {
    ?dimension a qb:DimensionProperty ;
    qb:concept ?concept ;
    rdfs:range ?range .
    OPTIONAL {?dimension qb:codeList ?codelist .
    ?codelist skos:hasTopConcept ?codeu .
    ?codeu skos:prefLabel ?code . }
    } ORDER BY ?code
    """)
    values = sparql.query().convert()
    #Finally, prepare the CSV query URL
    params = { "default-graph-uri" : "", "query" : query, "format" : "text/csv", "timeout" : 0, "debug" : "on"}
    url = "http://lod.cedar-project.nl:8080/sparql/cedar?" + urllib.urlencode(params)
    return template('query', state='results', numbers=numbers, variables=variables, values=values, prevvar=variable, prevval=value, sumcheck=sumcheck, url=url)

@route('/harmonize/admin')
def admin():
    return template('admin')

@route('/harmonize/clear')
def clear():
    sparql = SPARQLWrapper("http://lod.cedar-project.nl:8080/sparql/cedar")
    query = """
    DELETE { GRAPH <http://lod.cedar-project.nl/resource/harm> {?s ?p ?o .}}
    WHERE { GRAPH <http://lod.cedar-project.nl/resource/harm> {?s ?p ?o .}}
    """
    sparql.setQuery(query)
    sparql.setReturnFormat(JSON)
    sparql.query().convert()
    return admin()
    

# Static Routes
@route('/js/<filename:re:.*\.js>')
def javascripts(filename):
    return static_file(filename, root='views/js')

@route('/css/<filename:re:.*\.css>')
def stylesheets(filename):
    return static_file(filename, root='views/css')

@route('/img/<filename:re:.*\.(jpg|png|gif|ico)>')
def images(filename):
    return static_file(filename, root='views/img')

@route('/fonts/<filename:re:.*\.(eot|ttf|woff|svg)>')
def fonts(filename):
    return static_file(filename, root='views/fonts')


run(host = 'localhost', port = 8080, debug = True)
