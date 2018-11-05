// variables
variable
  = name:numeric_variable {
    return name
  } / name:string_variable {
    return name
  }

numeric_variable
  = simple_numeric_variable /
    numeric_array_element

// ex. A1, B20
simple_numeric_variable
  = letter:letter digits:digit? {
    const variableName = letter + (digits ? digits.join(''): '')
    return {
      type: 'MemberExpression',
      computed: false,
      object: {
        type: 'Identifier',
        name: 'global'
      },
      property: {
        type: 'Identifier',
        name: variableName
      }
    };
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
    return letter + "$"
  }
