start = program
program = blocks:block* endLine:end_line {
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
      valueObject: $.literal(lineNumber)
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

  const properties = _.map(blocks, (block) => {
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

  const endProperties = () => {
    return $.property({
      keyName: "\"" + String(endLine.lineNumber) + "\"",
      valueObject: $.objectExpression([
        $.property({
          keyName: 'func',
          valueObject: $.functionExpression({
            name: null,
            blockStatement: $.blockStatement({
              bodyArray: []
            })
          })
        }),
        lineNumberProperty(endLine.lineNumber)
      ])
    });
  };

  return programObject(properties.concat(endProperties()));
}

block
  = line:line / for_block
line_number
  = number:$(digit+) { return Number(number) }
line
  = line_number:line_number _ statement:statement __ {
    return {
      lineNumber: line_number,
      statement: statement,
    }
  }
end_statement
  = "END" {
    return $.expressionStatement($.functionExpression({
      blockStatement: $.blockStatement({
        bodyArray: []
      })
    }))
  }

end_line
  = lineNumber:line_number _ statement:end_statement __ {
    return { lineNumber, statement }
  }
statement
  = print_statement /
//  = data_statement / def_statement /
//    dimension _statement / gosub_statement /
  goto_statement /
  if_then_statement /
  let_statement
//    input_statement /
//    on_goto_statement / option_statement /
//    print_statement / randomize_statement /
//    read_statement / remark_statement /
//    restore_statement / return_statement /
//    stop_statement
// expressions

// controll statement
goto_statement
  = "GO" _ "TO" _ lineNumber:line_number {
    return $.expressionStatement($.callGotoExpression(lineNumber))
  }
if_then_statement
  = "IF" _ testExpression:relational_expression _ "THEN" _ lineNumber:line_number {
    // test expression is identifier or binary expression
    return $.ifStatement({ testExpression, lineNumber })
  }
relational_expression
  = left:numeric_expression _ operator:relation _ right:numeric_expression {
      return $.binaryExpression({ left, right, operator })
    } /
    left:string_expression _ operator:equality_relation _ right:string_expression {
      return $.binaryExpression({ left, right, operator })
    }
relation
  = equality_relation / "<" / ">" / not_less / not_greater
equality_relation
  = equals / not_equals
equals
  = "=" { "==" }
not_less
  = ">="
not_greater
  = "<="
not_equals
  = "<>" { "!==" }
