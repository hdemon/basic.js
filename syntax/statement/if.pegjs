if_then_statement
  = "IF" _ testExpression:relational_expression _ "THEN" _ lineNumber:line_number {
    // test expression is identifier or binary expression
    return $.ifStatement({ testExpression, lineNumber })
  }
