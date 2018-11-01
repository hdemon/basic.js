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
  = equality_relation / less_than_sign / greater_than_sign / not_less / not_greater
equality_relation
  = equals / not_equals
equals
  = "=" { return Symbol('euqals') }
greater_than_sign
  = ">" { return Symbol('greater_than_sign') }
less_than_sign
  = "<" { return Symbol('less_than_sign') }
not_less
  = ">=" { return Symbol('not_less') }
not_greater
  = "<=" { return Symbol('not_greater') }
not_equals
  = "<>" { return Symbol('not_euqals') }
