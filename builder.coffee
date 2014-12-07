_ = require 'lodash'

class Builder
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

  ifStatement: (args) ->
    type: 'IfStatement'
    test: args.testExpression
    consequent:
      type: 'ExpressionStatement'
      expression: @callGotoExpression args.lineNumber
    alternate: null

  variableDeclaration: (declarationObjects) ->
    type: 'VariableDeclaration'
    declarations: declarationObjects
    kind: 'var'

  variableDeclarator: (args) ->
    type: 'VariableDeclarator'
    id:
      type: 'Identifier'
      name: args.variableName
    init: args.expression

    # type: 'Literal'
    # value: args.value
    # raw: String args.value

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

  callExpression: (args) ->
    type: 'CallExpression'
    callee:
      type: 'MemberExpression'
      computed: false
      object:
        type: 'Identifier'
        name: args.object
      property:
        type: 'Identifier'
        name: args.property
    arguments: args.args

  functionExpression: (args) ->
    type: 'FunctionExpression'
    id: args.name || null
    params: []
    defaults: []
    body: args.blockStatement
    rest: null
    generator:  false
    expression: false

  binaryExpression: (args) ->
    type: 'BinaryExpression'
    operator: args.operator
    left: args.left
    right: args.right

  variableExpression: (variableName) ->
    type: 'MemberExpression'
    computed: false
    object:
      type: 'Identifier'
      name: 'global'
    property:
      type: 'Identifier'
      name: variableName

  buildBinaryExpressionRecursively: (args) =>
    term = args.rights.pop()
    left = args.left
    right = term.value
    operator = term.operator

    expression = @binaryExpression {left, right, operator}

    if args.rights.length <= 0
      expression
    else
      @buildBinaryExpressionRecursively
        left: expression
        rights: args.rights

  literal: (value) ->
    type: 'Literal'
    value: value

  assignToVariable: (args) =>
    @expressionStatement
      type: 'AssignmentExpression'
      operator: '='
      left: args.variableExpression
      right: args.expression

  callGotoExpression: (lineNumber) =>
    @controllerMethodCall
      methodName: '__goto'
      arguments: [
        type: 'ThisExpression'
        @literal lineNumber
      ]

  removeWhiteSpace: (array) ->
    _.reject array, (element) -> element == [' ']

module.exports = Builder