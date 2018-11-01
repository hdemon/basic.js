// variables
variable
  = numeric_variable / string_variable
numeric_variable
  // = variableName:simple_numeric_variable / numeric_array_element {
  = simple_numeric_variable
simple_numeric_variable
  = letter:letter digits:digit? {
    let name = letter
    if (digits) {
      name += digits.join('')
    }
    return $.variableExpression(name)
  }
numeric_array_element
  = numeric_array_name subscript
numeric_array_name
  = letter
subscript
  = "(" numeric_expression ("." numeric_expression)? ")"
string_variable
  = letter:letter "$" {
    return $.variableExpression(letter + "$")
  }
