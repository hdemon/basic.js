var escodegen = require('escodegen'),
  pj = require('prettyjson'),
  PEG = require('pegjs'),
  coffee = require('pegjs-coffee-plugin'),
  fs = require('fs'),
  argv = require('optimist').argv;

var base = [
  'base',
  'character',
  'variable',
  'constant',
  'expression',
].map((file) => fs.readFileSync(`syntax/base/${file}.pegjs`).toString()).join('')
var statements = fs.readdirSync('syntax/statement/').map((file) => fs.readFileSync(`syntax/statement/${file}`).toString()).join('');
const dependencies = `
{
  Builder = require process.cwd() + '/lib/builder'
  @_ = require 'lodash'
  @$ = new Builder
}
`;

var peg = dependencies + base + statements,
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
