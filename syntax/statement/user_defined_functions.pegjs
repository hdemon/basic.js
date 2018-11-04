def_statement
  = DEF _ numeric_defined_function _ parameter_list? _ equals_sign _ numeric_expression

numeric_defined_function
  = FN letter

parameter_list
  = left_parenthesis _ parameter _ right_parenthesis

parameter
  = simple_numeric_variable

DEF
  = "DEF"

FN
  = "FN"
