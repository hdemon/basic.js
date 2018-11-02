on_goto_statement
  = ON numeric_expression GO _ TO line_number (full_stop line_number)*

// controll statement
goto_statement
  = GO _ TO _ lineNumber:line_number {
    return $.expressionStatement($.callGotoExpression(lineNumber))
  }

ON
  = "ON"

GO
  = "GO"

TO
  = "TO"
