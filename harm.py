from bottle import route, run, template, request, static_file
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
    return template('harm', state='vocab', foobar='baz')

@route('/harmonize/upload', method='POST')
def upload():
    # category = request.forms.get('category')
    upload = request.files.get('upload')
    name, ext = os.path.splitext(upload.filename)
    if ext not in ('.xls'):
        return 'File extension ' + ext  + ' not allowed.'

    save_path = '../input/in.xls'
    upload.save(save_path, overwrite = True) # appends upload.filename automatically
    return template('harm', state='uploaded')

@route('/harmonize/download')
def download():
    return static_file('in.ttl', root = '../output/', download = 'tablinker.ttl')

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

