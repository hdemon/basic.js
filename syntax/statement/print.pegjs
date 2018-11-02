print_statement
  = "PRINT" _ list:print_list {
    return $.expressionStatement($.callExpression({
      object: "console",
      property: "log",
      args: [...list],
    }))
  }

print_list
  = list:(print_separator? _ print_item _ )+ {
    return list.map(match=>match[2])
  }

print_item
  = expression / tab_call

tab_call
  = "TAB" "(" numeric_expression ")"

print_separator
  = ","
