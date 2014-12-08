var escodegen = require('escodegen'),
  pj = require('prettyjson'),
  PEG = require('pegjs'),
  coffee = require('pegjs-coffee-plugin'),
  fs = require('fs'),
  argv = require('optimist').argv;

var peg = fs.readFileSync('src/ecma55.pegjs').toString(),
  initializerCode = fs.readFileSync('src/initializer.js').toString(),
  controllerCode = fs.readFileSync('src/controller.js').toString(),
  sourceCode = fs.readFileSync(argv._[0]).toString();

var generateParser = function(src) {
  return PEG.buildParser(src, { plugins: [coffee] });
};

var parseToAst = function(parserCode, code) {
  var parser = generateParser(parserCode);
  return parser.parse(code);
};

var ast = parseToAst(peg, sourceCode);
console.log(initializerCode + escodegen.generate(ast) + controllerCode);
