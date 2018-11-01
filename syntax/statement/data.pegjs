data_statement
  = numeric_data_statement / string_data_statement

numeric_data_statement
  = "DATA" _ numeric:numeric_constant __ {
    return $.pushNumericData({numeric})
  }
string_data_statement
  = "DATA" _ string:string_constant __ {
    return $.pushStringData({string})
  }

read_statement
  = numeric_read_statement / string_read_statement

numeric_read_statement
  = "READ" _ variableExpression:numeric_variable __ {
    return $.readDataToVariable({ variableExpression })
  }

string_read_statement
  = "READ" _ variableExpression:string_variable __ {
    return $.readDataToVariable({ variableExpression })
  }
