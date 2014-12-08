#!/usr/bin/env coffee

# the below is almost quoted from http://qiita.com/mizchi/items/b22080a52bb3bcd7215a directly.
escodegen = require 'escodegen'
pj = require 'prettyjson'
PEG = require 'pegjs'
coffee = require 'pegjs-coffee-plugin'
fs = require 'fs'
argv = require('optimist').argv

peg = fs.readFileSync('src/ecma55.pegjs').toString()
initializerCode = fs.readFileSync('src/initializer.js').toString()
controllerCode = fs.readFileSync('src/controller.js').toString()
sourceCode = fs.readFileSync(argv._[0]).toString()

generateParser = (src) -> PEG.buildParser src, { plugins: [coffee] }
parseToAst = (parserCode, code) ->
  parser = generateParser parserCode
  parser.parse code

ast = parseToAst peg, sourceCode
# console.log pj.render ast
console.log initializerCode + escodegen.generate(ast) + controllerCode
