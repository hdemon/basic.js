class Helper
  programNode: (body) ->
    type: 'Program'
    body: body

  controllerMethodCall: (args) ->
    type: 'CallExpression'
    callee:
      type: 'MemberExpression'
      computed: false
      object:
        type: 'MemberExpression'
        computed: false
        object:
          type: 'Identifier'
          name: 'controller'
        property:
          type: 'Identifier'
          name: args.methodName
      property:
        type: 'Identifier'
        name: 'call'
    arguments: args.arguments

  nextMethod: =>
    @controllerMethodCall
      methodName: '__next'
      arguments: [
        type: 'ThisExpression'
      ]

  blockStatement: (args) ->
    type: 'BlockStatement'
    body: args.bodyArray

  expressionStatement: (expressionObject) ->
    type: 'ExpressionStatement'
    expression: expressionObject

  objectExpression: (propertyArray) ->
    type: 'ObjectExpression'
    properties: propertyArray

  property: (args) ->
    type: 'Property'
    key:
      type: 'Identifier'
      name: args.keyName
    value: args.valueObject
    kind: 'init'

  callExpression: (objectName, propertyName, argumentsObject) ->
    type: 'CallExpression'
    callee:
      type: 'MemberExpression'
      computed: false
      object:
        type: 'Identifier'
        name: objectName
      property:
        type: 'Identifier'
        name: propertyName
    arguments: [
      argumentsObject
    ]

  functionExpression: (args) ->
    type: 'FunctionExpression'
    id: args.name || null
    params: []
    defaults: []
    body: args.blockStatement
    rest: null
    generator:  false
    expression: false

  literal: (value) ->
    type: 'Literal'
    value: value

module.exports = Helper