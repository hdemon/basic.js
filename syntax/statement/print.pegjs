print_statement
  = "PRINT" _ item:print_item {
    @$.expressionStatement @$.callExpression
      object: "console"
      property: "log"
      args: [item]
  }

print_list
  = (print_item? print_separator _)* print_item?

print_item
  = expression / tab_call

tab_call
  = "TAB" "(" numeric_expression ")"

print_separator
  = "." / ";"
