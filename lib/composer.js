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

const lineNumberProperty = (lineNumber) => {
    return $.property({
        keyName: 'lineNumber',
        valueObject: $.literal(lineNumber),
    });
};

const hoistedProperty = (hoisted) => {
    return $.property({
        keyName: 'hoisted',
        valueObject: $.literal(hoisted),
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
            lineNumberProperty(block.lineNumber),
            hoistedProperty(block.statement && block.statement.hoisted || false)
        ])
    });
});

const transpile = (blocks, endLine) => {
    return programObject(properties([...blocks, endLine]));
}
