restore_statement
  = "RESTORE" __ {
    return $.resetDataIndex()
  }
data_statement
  = "DATA" _ list:data_list {
    return $.pushData({list})
  }

data_list
  = list:(data_separator? _ data_item _ )+ {
    return list.map(match=>match[2])
  }

data_item
  = numeric_data_item / string_data_item

string_data_item
  = string_constant

numeric_data_item
  = match:numeric_constant {
    return match[1]
  }

data_separator
  = "," / ";"

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
