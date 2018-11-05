print_statement
  = PRINT _ list:print_list {
    return { statement: 'PRINT', list }
  }

print_list
  = list:(print_separator? _ print_item _ )+ {
    return list.map(match => match[2])
  }

print_item
  = expression / tab_call

tab_call
  = TAB left_parenthesis numeric_expression right_parenthesis

print_separator
  = comma / semi_colon

PRINT
  = "PRINT"

TAB
  = "TAB"
