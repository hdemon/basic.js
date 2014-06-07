# the below is almost quoted from http://qiita.com/mizchi/items/b22080a52bb3bcd7215a directly.
escodegen = require 'escodegen'
esprima = require 'esprima'
pj = require 'prettyjson'
PEG = require 'pegjs'
coffee = require 'pegjs-coffee-plugin'
fs = require 'fs'

p = console.log.bind console

# show ast tree
get_js_ast = (code) -> pj.render esprima.parse code
json_dump = (code)-> p pj.render code

# pegjs parser
gen_parser = (src) -> PEG.buildParser src, {plugins: [coffee]}
parse_with_gen = (parser_code, code) ->
  parser = gen_parser parser_code
  parser.parse code

# pegjs parser and ast
parse_with_gen_and_escodegen = (parser_code, code) ->
  parser = gen_parser parser_code
  escodegen.generate parser.parse code

parse_with_gen_and_escodegen_exec = (parser_code, code) ->
  eval parse_with_gen_and_escodegen parser_code, code

peg_parser = fs.readFileSync('ecma55.pegjs').toString()

code = """
10 PRINT "ABC"
20 PRINT "DEF"
999 END
"""

p '-----------' + new Date
data = parse_with_gen peg_parser, code

p code
p pj.render data

p escodegen.generate data
