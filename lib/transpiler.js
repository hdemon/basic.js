const escodegen = require('escodegen'),
  jsome = require('jsome'),
  pj = require('prettyjson'),
  peg = require('pegjs-dev'),
  fs = require('fs'),
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
const composer = fs.readFileSync('lib/composer.js')

const syntax = `{
  const Builder = require('${`${process.cwd()}/lib/builder`}')\n
  const $ = new Builder
  \n${composer}\n
}\n` + base + statements;
const initializerCode = fs.readFileSync('lib/initializer.js').toString();
const controllerCode = fs.readFileSync('lib/controller.js').toString();

const ast = peg.parser.parse(syntax);
var passes = peg.util.convertPasses( peg.compiler.passes );
var session = new peg.compiler.Session({ passes });
const parser = peg.compiler.compile(ast, session, { trace: Boolean(argv.trace) });

exports.run = (argv) => {
  const sourceCode = fs.readFileSync(argv._[0]).toString();
  const jsAst = parser.parse(sourceCode);
  if (argv.ast) {
    console.log(pj.render(jsAst))
    process.exit(0)
  }
  const output = (initializerCode + escodegen.generate(jsAst) + controllerCode)
  if (argv.output) {
    console.log(output)
  } else {
    eval(output)
  }
}
