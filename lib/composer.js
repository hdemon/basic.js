const _ = require('lodash')

const programObject = (properties) => {
    return {
        type: 'Program',
        body: [
        {
            type: 'ExpressionStatement',
            expression: {
            type: 'AssignmentExpression',
            operator: '=',
            left: {
                type: 'Identifier',
                name: 'program'
            },
            right: $.objectExpression(properties)
            }
        }
        ]
    };
};

const binaryExpression = (args) => {
    return {
      type: 'BinaryExpression',
      operator: args.operator,
      left: args.left,
      right: args.right
    };
  }

const buildBinaryExpressionRecursively = (args) => {
    var expression, left, operator, right, term;
    term = args.rights.pop();
    left = args.left;
    right = term.value;
    operator = term.operator;
    expression = binaryExpression({left, right, operator})
    if (args.rights.length <= 0) {
      return expression;
    } else {
      return buildBinaryExpressionRecursively({
        left: expression,
        rights: args.rights
      });
    }
  }

const lineNumberProperty = (lineNumber) => {
    return $.property({
        keyName: 'lineNumber',
        valueObject: $.literal(lineNumber),
    });
};

const nextMethod = () => {
    return $.controllerMethodCall({
        methodName: '__next',
        arguments: [
        {
            type: 'ThisExpression'
        }
        ]
    });
};

const properties = (blocks) => _.map(blocks, (block) => {
    return $.property({
        keyName: "\"" + String(block.lineNumber) + "\"",
        valueObject: $.objectExpression([
            $.property({
                keyName: 'func',
                valueObject: $.functionExpression({
                    name: null,
                    blockStatement: $.blockStatement({
                        bodyArray: [block.statement, $.expressionStatement(nextMethod())]
                    })
                })
            }),
            lineNumberProperty(block.lineNumber)
        ])
    });
});

const callExpression = (args) => {
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


const transpile = (blocks, endLine) => {
    return programObject(properties([...blocks, endLine]));
}
