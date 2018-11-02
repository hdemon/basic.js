expression
  = string_expression / numeric_expression

// 加減算より乗算、乗算より累乗が優先的にパースされる。したがって乗算や累乗がある場合、加減算はtailに入る。
numeric_expression
  = sign:sign? head:term _ tail:(_ sign _ term)* {
    return { sign, head, tail }
  }

term
  = factor:factor _ tail:(multiplier _ factor)* {
    return { factor, tail }
  }

factor
  = primary:primary _ tail:(_ circumflex_accent _ primary)* {
    return { primary, tail }
  }

multiplier
  = asterisk / solidus
// primary = numeric_variable / numeric_rep / numeric_function_ref / "(" numeric_expression ")"

primary
  // = variable:numeric_variable / rep:numeric_rep /
  = string:numeric_variable / string:numeric_constant /
    left_parenthesis numeric_expression right_parenthesis
// numeric_function_ref = numeric_function_name argument_list?
// numeric_function_name = numeric_defined_function / numeric_supplied_function

argument_list
  = left_parenthesis argument right_parenthesis

argument
  = string_expression

string_expression
  = string_variable / string_constant
