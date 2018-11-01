const escodegen = require('escodegen'),
  pj = require('prettyjson'),
  peg = require('pegjs-dev'),
  fs = require('fs'),
  esvalid = require('esvalid'),
  colors = require('colors/safe'),
  argv = require('optimist').argv;

const base = [
  'base',
  'character',
  'variable',
  'constant',
  'expression',
].map((file) => fs.readFileSync(`syntax/base/${file}.pegjs`).toString()).join('')
const statements = fs.readdirSync('syntax/statement/').map((file) => fs.readFileSync(`syntax/statement/${file}`).toString()).join('');
const dependencies = `
{
  const Builder = require('${`${process.cwd()}/lib/builder`}')
  const _ = require('lodash')
  const $ = new Builder
}
`;

const syntax = dependencies + base + statements,
  initializerCode = fs.readFileSync('lib/initializer.js').toString(),
  controllerCode = fs.readFileSync('lib/controller.js').toString();

const ast = peg.parser.parse(syntax);
var passes = peg.util.convertPasses( peg.compiler.passes );
var session = new peg.compiler.Session({ passes });
const parser = peg.compiler.compile(ast, session, { trace: true });

exports.run = (sourcePath) => {
  const sourceCode = fs.readFileSync(sourcePath).toString();
  const jsAst = parser.parse(sourceCode);
  const errors = esvalid.errors(jsAst)
  if (errors) {
    console.error(colors.red('Generated AST is invalid.'));
    console.error(errors);
    process.exit(1);
  }
  eval(initializerCode + escodegen.generate(jsAst) + controllerCode)
}
