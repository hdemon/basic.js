// variables
variable
  = name:numeric_variable / name:string_variable

numeric_variable
  // = variableName:simple_numeric_variable / numeric_array_element {
  = simple_numeric_variable

// ex. A1, B20
simple_numeric_variable
  = letter:letter digits:digit? {
    let name = letter + (digits && digits.join(''))
    return $.variableExpression(name)
  }

// ex. V(3)
numeric_array_element
  = numeric_array_name subscript

numeric_array_name
  = letter

subscript
  = left_parenthesis numeric_expression (comma numeric_expression)? right_parenthesis

string_variable
  = letter:letter dollar_sign {
    // return letter + "$"
    return $.variableExpression(letter + "$")
  }
