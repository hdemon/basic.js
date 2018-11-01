if_then_statement
  = "IF" _ testExpression:relational_expression _ "THEN" _ lineNumber:line_number {
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
  = "=" { return "==" }
not_less
  = ">="
not_greater
  = "<="
not_equals
  = "<>" { return "!==" }
