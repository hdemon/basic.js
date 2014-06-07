esprima = require 'esprima'
escodegen = require 'escodegen'
pj = require 'prettyjson'

p = -> console.log pj.render arguments...
p esprima.parse """
function line10() {
  console.log("a");
}
function line10() {
  return 1;
}
"""


# escodegen
#   statement:
#     type:      "CallExpression"
#     callee:
#       type:     "MemberExpression"
#       computed: false
#       object:
#         type: "Identifier"
#         name: "console"
#       property:
#         type: "Identifier"
#         name: "log"
#     arguments:
#       type:  "Literal"
#       value: "ABC"


# type: Program
# body:
#   -
#     type:       ExpressionStatement
#     expression:
#       type:      CallExpression
#       callee:
#         type:     MemberExpression
#         computed: false
#         object:
#           type: Identifier
#           name: console
#         property:
#           type: Identifier
#           name: log
#       arguments:
#         -
#           type:  Literal
#           value: A
#           raw:   "A"