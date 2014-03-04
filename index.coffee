fs = require 'fs'
xml2js = require 'xml2js'
parser = require './lib/parser.coffee'
writer = require './lib/writer.coffee'

inputfile = process.argv[2]

console.log 'reading from', inputfile

xml_parser = xml2js.Parser()

fs.readFile inputfile, (err, data) ->
  xml_parser.parseString data, (err, result) ->
    parsed = parser.wrapper result
    writer.write_content parsed
    writer.write_authors parsed.globals.authors
