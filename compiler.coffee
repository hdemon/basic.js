#!/usr/bin/env coffee

# the below is almost quoted from http://qiita.com/mizchi/items/b22080a52bb3bcd7215a directly.
escodegen = require 'escodegen'
esprima = require 'esprima'
pj = require 'prettyjson'
PEG = require 'pegjs'
coffee = require 'pegjs-coffee-plugin'
fs = require 'fs'
argv = require('optimist').argv


p = console.log.bind console


# show ast treej;
getJsAst = (code) -> pj.render esprima.parse code
jsonDump = (code)-> p pj.render code

# pegjs parser
genParser = (src) -> PEG.buildParser src, {plugins: [coffee]}
parseWithGen = (parserCode, code) ->
  parser = genParser parserCode
  parser.parse code

# pegjs parser and ast
parseWithGenAndEscodegen = (parserCode, code) ->
  parser = genParser parserCode
  escodegen.generate parser.parse code

parseWithGenAndEscodegenExec = (parserCode, code) ->
  eval parseWithGenAndEscodegen parserCode, code


fileName = argv._[0]
pegParser = fs.readFileSync('ecma55.pegjs').toString()
sourceCode = fs.readFileSync(fileName).toString()


controllerCode = """
controller = {};

controller.__next = function() {
  var lineIndexes = Object.keys(program);
  var currentLineIndex = lineIndexes.indexOf(String(this.lineNumber));
  var nextLineNumber = lineIndexes[currentLineIndex + 1];
  if (nextLineNumber) {
    program[String(nextLineNumber)].func();
  }
};

controller.__goto = function(lineNumber) {
  program[String(lineNumber)].func();
};

controller.__start = function() {
  var lineIndexes = Object.keys(program);
  program[String(lineIndexes[0])].func();
};

controller.__start();
"""

data = parseWithGen pegParser, sourceCode
# p pj.render data
console.log escodegen.generate(data) + controllerCode
