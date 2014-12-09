var escodegen = require('escodegen');


console.log(escodegen.generate(
{
                "type": "ObjectExpression",
                "properties": [
                  {
                    "type": "Property",
                    "key": {
                      "type": "Identifier",
                      "name": "func"
                    },
                    "value": {
                      "type": "FunctionExpression",
                      "id": null,
                      "params": [

                      ],
                      "defaults": [

                      ],
                      "body": {
                        "type": "BlockStatement",
                        "body": [
                          {
                            "type": "IfStatement",
                            "test": {
                              "type": "BinaryExpression",
                              "operator": "==",
                              "left": {
                                "type": "MemberExpression",
                                "computed": false,
                                "object": {
                                  "type": "Identifier",
                                  "name": "global"
                                },
                                "property": {
                                  "type": "Identifier",
                                  "name": "A"
                                }
                              },
                              "right": {
                                "type": "Literal",
                                "value": 1,
                                "raw": "1"
                              }
                            },
                            "consequent": {
                              "type": "ExpressionStatement",
                              "expression": {
                                "type": "CallExpression",
                                "callee": {
                                  "type": "MemberExpression",
                                  "computed": false,
                                  "object": {
                                    "type": "MemberExpression",
                                    "computed": false,
                                    "object": {
                                      "type": "Identifier",
                                      "name": "controller"
                                    },
                                    "property": {
                                      "type": "Identifier",
                                      "name": "__goto"
                                    }
                                  },
                                  "property": {
                                    "type": "Identifier",
                                    "name": "call"
                                  }
                                },
                                "arguments": [
                                  {
                                    "type": "ThisExpression"
                                  },
                                  {
                                    "type": "Literal",
                                    "value": 40
                                  }
                                ]
                              }
                            },
                            "alternate": null
                          },
                        ]
                      },
                      "rest": null,
                      "generator": false,
                      "expression": false
                    },
                    "kind": "init"
                  },

                ]

}
));
