let_statement
  = numeric_let_statement / string_let_statement

numeric_let_statement
  = LET _ variableExpression:numeric_variable _ equals_sign _ expression:numeric_expression __ {
    return $.assignToVariable({ variableExpression, expression })
  }

string_let_statement
  = LET _ variableExpression:string_variable _ equals_sign _ expression:string_expression __ {
    return $.assignToVariable({ variableExpression, expression })
  }

LET
  = "LET"
