let_statement
  = _args:numeric_let_statement {
    return { statement: 'LET', arguments: _args }
  }
  / _args:string_let_statement {
    return { statement: 'LET', arguments: _args }
  }

numeric_let_statement
  = LET _ variable_name:numeric_variable _ equals_sign _ expression:numeric_expression __ {
    return { variable_name, expression }
  }

string_let_statement
  = LET _ variable_name:string_variable _ equals_sign _ expression:string_expression __ {
    return { variable_name, expression }
  }

LET
  = "LET"
