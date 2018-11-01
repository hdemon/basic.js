var Builder, _;

_ = require('lodash');

Builder = class Builder {
  constructor() {
    this.nextMethod = this.nextMethod.bind(this);
    this.buildBinaryExpressionRecursively = this.buildBinaryExpressionRecursively.bind(this);
    this.assignToVariable = this.assignToVariable.bind(this);
    this.callGotoExpression = this.callGotoExpression.bind(this);
  }

  programNode(body) {
    return {
      type: 'Program',
      body: body
    };
  }

  controllerMethodCall(args) {
    return {
      type: 'CallExpression',
      callee: {
        type: 'MemberExpression',
        computed: false,
        object: {
          type: 'MemberExpression',
          computed: false,
          object: {
            type: 'Identifier',
            name: 'controller'
          },
          property: {
            type: 'Identifier',
            name: args.methodName
          }
        },
        property: {
          type: 'Identifier',
          name: 'call'
        }
      },
      arguments: args.arguments
    };
  }

  nextMethod() {
    return this.controllerMethodCall({
      methodName: '__next',
      arguments: [
        {
          type: 'ThisExpression'
        }
      ]
    });
  }

  blockStatement(args) {
    return {
      type: 'BlockStatement',
      body: args.bodyArray
    };
  }

  expressionStatement(expressionObject) {
    return {
      type: 'ExpressionStatement',
      expression: expressionObject
    };
  }

  ifStatement(args) {
    return {
      type: 'IfStatement',
      test: args.testExpression,
      consequent: {
        type: 'ExpressionStatement',
        expression: this.callGotoExpression(args.lineNumber)
      },
      alternate: null
    };
  }

  variableDeclaration(declarationObjects) {
    return {
      type: 'VariableDeclaration',
      declarations: declarationObjects,
      kind: 'var'
    };
  }

  variableDeclarator(args) {
    return {
      type: 'VariableDeclarator',
      id: {
        type: 'Identifier',
        name: args.variableName
      },
      init: args.expression
    };
  }

  // type: 'Literal'
  // value: args.value
  // raw: String args.value
  objectExpression(propertyArray) {
    return {
      type: 'ObjectExpression',
      properties: propertyArray
    };
  }

  property(args) {
    return {
      type: 'Property',
      key: {
        type: 'Identifier',
        name: args.keyName
      },
      value: args.valueObject,
      kind: 'init'
    };
  }

  callExpression(args) {
    return {
      type: 'CallExpression',
      callee: {
        type: 'MemberExpression',
        computed: false,
        object: {
          type: 'Identifier',
          name: args.object
        },
        property: {
          type: 'Identifier',
          name: args.property
        }
      },
      arguments: args.args
    };
  }

  functionExpression(args) {
    return {
      type: 'FunctionExpression',
      id: args.name || null,
      params: [],
      defaults: [],
      body: args.blockStatement,
      rest: null,
      generator: false,
      expression: false
    };
  }

  binaryExpression(args) {
    return {
      type: 'BinaryExpression',
      operator: args.operator,
      left: args.left,
      right: args.right
    };
  }

  variableExpression(variableName) {
    return {
      type: 'MemberExpression',
      computed: false,
      object: {
        type: 'Identifier',
        name: 'global'
      },
      property: {
        type: 'Identifier',
        name: variableName
      }
    };
  }

  buildBinaryExpressionRecursively(args) {
    var expression, left, operator, right, term;
    term = args.rights.pop();
    left = args.left;
    right = term.value;
    operator = term.operator;
    expression = this.binaryExpression({left, right, operator});
    if (args.rights.length <= 0) {
      return expression;
    } else {
      return this.buildBinaryExpressionRecursively({
        left: expression,
        rights: args.rights
      });
    }
  }

  literal(value) {
    return {
      type: 'Literal',
      value: value
    };
  }

  assignToVariable(args) {
    return this.expressionStatement({
      type: 'AssignmentExpression',
      operator: '=',
      left: args.variableExpression,
      right: args.expression
    });
  }

  callGotoExpression(lineNumber) {
    return this.controllerMethodCall({
      methodName: '__goto',
      arguments: [
        {
          type: 'ThisExpression'
        },
        this.literal(lineNumber)
      ]
    });
  }

  removeWhiteSpace(array) {
    return _.reject(array, function(element) {
      return element === [' '];
    });
  }

};

module.exports = Builder;