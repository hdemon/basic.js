let_statement
  = numeric_let_statement / string_let_statement {
    return { statement: 'LET'  }
  }

numeric_let_statement
  = LET _ variable_name:numeric_variable _ equals_sign _ expression:numeric_expression __

string_let_statement
  = LET _ variable_name:string_variable _ equals_sign _ expression:string_expression __

LET
  = "LET"
