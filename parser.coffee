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

# program = {
#   "10": {
#     func: function() {
#       console.log("ABC");
#       program.__next.call(this);
#     },
#     lineNumber: 10,
#   },

#   "20": {
#     func: function() {
#       console.log("DEF");
#       program.__next.call(this);
#     },
#     lineNumber: 20,
#   },

#   "30": {
#     func: function() {
#       program.__goto(10).call(this);
#       program.__next.call(this);
#     },
#     lineNumber: 30,
#   },
# }

# program.__next = function() {
#   var lineIndexes = Object.keys(program);
#   var currentLineIndex = lineIndexes.indexOf(String(this.lineNumber));
#   var nextLineNumber = lineIndexes[currentLineIndex + 1];
#   program[String(nextLineNumber)].func();
# }


p '-----------' + new Date
data = parse_with_gen peg_parser, code
p code
p pj.render data

p escodegen.generate data
