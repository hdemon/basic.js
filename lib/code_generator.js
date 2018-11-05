const Builder = require('./ast_builder')

const generateAST = (ir) => {
    const body = ir.map((line) => {
        const a = line.arguments
        switch (line.statement) {
            case 'LET':
                return {
                    type: "ExpressionStatement",
                    expression: {
                        type: "AssignmentExpression",
                        operator: '=',
                        left: a.variable_name,
                        right: a.expression,
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
                break;
            case 'RETURN':
                break;
            case 'PRINT':
                return Builder.printStatement({ ...line.arguments })
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
