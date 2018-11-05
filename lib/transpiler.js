const escodegen = require('escodegen');
const jsome = require('jsome');
const pj = require('prettyjson');
const peg = require('pegjs-dev');
const fs = require('fs');
const colors = require('colors/safe');
const argv = require('optimist').argv;
const generateAST = require('./code_generator')

const base = [
  'programs',
  'remarks',
  'characters_and_strings',
  'variable',
  'constant',
  'expression',
].map((file) => fs.readFileSync(`syntax/base/${file}.pegjs`).toString()).join('')
const statements = fs.readdirSync('syntax/statement/').map((file) => fs.readFileSync(`syntax/statement/${file}`).toString()).join('');
const composer = fs.readFileSync('lib/composer.js')

const syntax = `{ \n${composer}\n }\n` + base + statements;
const initializerCode = fs.readFileSync('lib/initializer.js').toString();
const controllerCode = fs.readFileSync('lib/controller.js').toString();

const ast = peg.parser.parse(syntax);
const passes = peg.util.convertPasses( peg.compiler.passes );
const session = new peg.compiler.Session({ passes });
const parser = peg.compiler.compile(ast, session, { trace: Boolean(argv.trace) });

exports.run = (argv) => {
  const sourceCode = fs.readFileSync(argv._[0]).toString();
  const ir = parser.parse(sourceCode);
  if (argv.ir) {
    jsome(ir)
    process.exit(0)
  }

  const ast = generateAST(ir)
  if (argv.ast) {
    jsome(ast)
  }
  const js = initializerCode + escodegen.generate(ast)
  if (argv.output) {
    console.log(js)
  } else {
    eval(js)
  }
}
