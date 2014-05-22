# the below is almost quote from http://qiita.com/mizchi/items/b22080a52bb3bcd7215a directly.
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

peg_parser = fs.readFileSync('alanpoe.pegjs').toString()

code = """
When I%3 equal zero and I%5 equal zero, shall '"FizzBuzz".
If I%3 equal zero, '"Buzz".
Ah 'Fizz, I%5 equal absence.
In so far as, I minus 100 equal nothingness.
"""

code = """
abc I def ghi, aa 'xxx.
def ghi, 'ggg fff.
xfg 'adf, gie hhh.
"""

p '-----------' + new Date
data = parse_with_gen peg_parser, code
p code
p pj.render data
