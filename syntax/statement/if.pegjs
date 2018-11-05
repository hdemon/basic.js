if_then_statement
  = IF _ _args:relational_expression _ THEN _ line_number:line_number {
    return { statement: 'IF', arguments: { ..._args, goto: line_number } }
  }

relational_expression
  = left:numeric_expression _ operator:relation _ right:numeric_expression {
    return { left, right, operator }
  } /
  left:string_expression _ operator:equality_relation _ right:string_expression {
    return { left, right, operator }
  }

relation
  = equality_relation / less_than_sign / greater_than_sign / not_less / not_greater

equality_relation
  = equals_sign { return "==" } / not_equals

not_less
  = greater_than_sign equals_sign

not_greater
  = less_than_sign equals_sign

not_equals
  = less_than_sign greater_than_sign { return "!==" }

IF
  = "IF"

THEN
  = "THEN"
