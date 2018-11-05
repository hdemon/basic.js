
const generateAST = (ir) => {
    const body = ir.map((line) => {
        const a = line.arguments
        switch (line.statement) {
            case 'LET':
                return {
                    "type": "FunctionDeclaration",
                    "id": {
                        "type": "Identifier",
                        "name": `LINE_${line.line_number}`
                    },
                    "params": [],
                    "body": {
                        "type": "BlockStatement",
                        "body": [{
                            type: "ExpressionStatement",
                            expression: {
                                type: "AssignmentExpression",
                                operator: '=',
                                left: a.variable_name,
                                right: a.expression,
                            }
                        }]
                    }
                }
                break;
            case 'DATA':
                // assign some value to 'data' array at global.
                break;
            case 'READ':
                // Read value from 'data' array at global. And forward cursor.
                break;
            case 'FOR':
                // Read value from 'data' array at global. And forward cursor.
                break;
            case 'GOSUB':
                break;
            case 'IF':
                return {
                    "type": "FunctionDeclaration",
                    "id": {
                        "type": "Identifier",
                        "name": `LINE_${line.line_number}`
                    },
                    "params": [],
                    "body": {
                        "type": "BlockStatement",
                        "body": [
                            {
                                "type": "IfStatement",
                                "test": {
                                    "type": "BinaryExpression",
                                    "operator": a.operator,
                                    "left": a.left,
                                    "right": a.right,
                                },
                                "consequent": {
                                    "type": "BlockStatement",
                                    "body": [
                                        {
                                            "type": "ExpressionStatement",
                                            "expression": {
                                                "type": "CallExpression",
                                                "callee": {
                                                    "type": "Identifier",
                                                    "name": `LINE_${a.goto}`
                                                },
                                                "arguments": []
                                            }
                                        }
                                    ]
                                },
                                "alternate": null
                            }
                        ]
                    }
                }
                break;
            case 'RETURN':
                break;
            case 'PRINT':
                return {
                    "type": "FunctionDeclaration",
                    "id": {
                        "type": "Identifier",
                        "name": `LINE_${line.line_number}`
                    },
                    "params": [],
                    "body": {
                        "type": "BlockStatement",
                        "body": [
                            {
                                "type": "ExpressionStatement",
                                "expression": {
                                    "type": "CallExpression",
                                    "callee": {
                                        "type": "MemberExpression",
                                        "computed": false,
                                        "object": {
                                            "type": "Identifier",
                                            "name": "console"
                                        },
                                        "property": {
                                            "type": "Identifier",
                                            "name": "log"
                                        }
                                    },
                                    "arguments": [
                                        {
                                            "type": "Identifier",
                                            "name": a.list
                                        }
                                    ]
                                }
                            }
                        ]
                    }
                }
                break;
            default:
                break;
        }
    })

    return {
        "type": "Program",
        "body": body,
        "sourceType": "script"
    }
}



module.exports = generateAST
