for_block
  = for_line for_body

for_body
  = block next_line

for_line
  = line_number _ for_statement __

next_line
  = line_number _ next_statement __

for_statement
  = FOR control_variable equals_sign initial_value TO limit (STEP increment)?

control_variable
  = simple_numeric_variable

initial_value
  = numeric_expression

limit
  = numeric_expression

increment
  = numeric_expression

next_statement
  = NEXT control_variable

FOR
  = "FOR"

// TO
//  = "TO"

STEP
  = "STEP"

NEXT
  = "NEXT"
