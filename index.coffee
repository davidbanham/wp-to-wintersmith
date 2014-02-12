fs = require 'fs'
xml2js = require 'xml2js'

inputfile = process.argv[2]

console.log 'reading from', inputfile

parser = xml2js.Parser()

fs.readFile inputfile, (err, data) ->
  parser.parseString data, (err, result) ->
    fs.writeFileSync 'out', JSON.stringify result
    console.dir result
