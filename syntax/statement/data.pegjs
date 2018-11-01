data_statement
  = numeric_data_statement / string_data_statement

numeric_data_statement
  = "DATA" _ expression:numeric_expression __ {
    @$.pushToData {expression}
  }
string_data_statement
  = "DATA" _ expression:string_expression __ {
    @$.pushToData {expression}
  }
