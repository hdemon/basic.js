let_statement
  = numeric_let_statement / string_let_statement

numeric_let_statement
  = "LET" _ variableExpression:numeric_variable _ "=" _ expression:numeric_expression __ {
    @$.assignToVariable {variableExpression, expression}
  }

string_let_statement
  = "LET" _ variableExpression:string_variable _ "=" _ expression:string_expression __ {
    @$.assignToVariable {variableExpression, expression}
  }
