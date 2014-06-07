esprima = require 'esprima'
escodegen = require 'escodegen'
pj = require 'prettyjson'

p = -> console.log pj.render arguments...
p esprima.parse """
console.log("A");
"""
p esprima.parse """
function line10() {
  console.log("A" + "B" + "C");
}
function line10() {
  console.log("A" + "B" + "C");
}
"""


escodegen
  statement:
    type:      "CallExpression"
    callee:
      type:     "MemberExpression"
      computed: false
      object:
        type: "Identifier"
        name: "console"
      property:
        type: "Identifier"
        name: "log"
    arguments:
      type:  "Literal"
      value: "ABC"


type: Program
body:
  -
    type:       ExpressionStatement
    expression:
      type:      CallExpression
      callee:
        type:     MemberExpression
        computed: false
        object:
          type: Identifier
          name: console
        property:
          type: Identifier
          name: log
      arguments:
        -
          type:  Literal
          value: A
          raw:   "A"