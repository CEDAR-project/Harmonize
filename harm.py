from bottle import route, run, template, request, static_file
from SPARQLWrapper import SPARQLWrapper, JSON
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
    return template('harm', state='start')

@route('/harmonize/vocab')
def vocab():
    sparql = SPARQLWrapper("http://lod.cedar-project.nl:8080/sparql/cedar")
    sparql.setQuery("""
    PREFIX sdmx: <http://purl.org/linked-data/sdmx#>
    PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
    
    SELECT ?var ?value
    FROM <http://lod.cedar-project.nl/resource/harmonization>
    WHERE {
    ?value skos:inScheme ?var .
    } GROUP BY ?var
    ORDER BY ?var
    """)
    sparql.setReturnFormat(JSON)
    results = sparql.query().convert()
    return template('harm', state='vocab', results=results)

@route('/harmonize/harm')
def harm():
    ds = request.query.ds
    if not ds:
        sparql = SPARQLWrapper("http://lod.cedar-project.nl:8080/sparql/cedar")
        sparql.setQuery("""
        PREFIX d2s: <http://www.data2semantics.org/core/>
        
        SELECT ?g
        FROM <http://lod.cedar-project.nl/resource/cedar-dataset>
        WHERE {
        GRAPH ?g {
        ?s d2s:dimension ?dim
        }
        } GROUP BY ?g ORDER BY ?g
        """)
        sparql.setReturnFormat(JSON)
        results = sparql.query().convert()
        return template('harm', state='manage-ds', files=results)
    else:
        sparql = SPARQLWrapper("http://lod.cedar-project.nl:8080/sparql/cedar")
        sparql.setQuery("""
        PREFIX d2s: <http://www.data2semantics.org/core/>

        SELECT DISTINCT(?dim) ?varname ?val
        FROM <%s> 
        FROM <http://lod.cedar-project.nl/resource/harm> 
        WHERE { 
        {GRAPH <http://lod.cedar-project.nl/resource/harm> {?dim ?var ?val .}}
        UNION 
        {?s d2s:dimension ?dim .}
        }
        """ % ds)
        sparql.setReturnFormat(JSON)
        results = sparql.query().convert()
        return template('harm', state='manage-variables', variables=results, ds=ds)

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


run(host = 'lod.cedar-project.nl', port = 8082, debug = True)

