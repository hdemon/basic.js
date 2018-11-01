var escodegen = require('escodegen'),
  pj = require('prettyjson'),
  PEG = require('pegjs'),
  coffee = require('pegjs-coffee-plugin'),
  fs = require('fs'),
  argv = require('optimist').argv;

var base = fs.readdirSync('syntax/base/').map((file) => fs.readFileSync(`syntax/base/${file}`).toString()).join('')
var statements = fs.readdirSync('syntax/statement/').map((file) => fs.readFileSync(`syntax/statement/${file}`).toString()).join('');

var peg = base + statements,
  initializerCode = fs.readFileSync('lib/initializer.js').toString(),
  controllerCode = fs.readFileSync('lib/controller.js').toString();

var generateParser = function(src) {
  return PEG.buildParser(src, { plugins: [coffee] });
};

var parseToAst = function(parserCode, code) {
  var parser = generateParser(parserCode);
  return parser.parse(code);
};

exports.run = function(sourcePath) {
  var sourceCode = fs.readFileSync(sourcePath).toString();
  var ast = parseToAst(peg, sourceCode);
  console.log(initializerCode + escodegen.generate(ast) + controllerCode);
}
