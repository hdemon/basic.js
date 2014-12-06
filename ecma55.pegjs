{
  Helper = require '../../../helper'
  @_ = require 'lodash'
  @$ = new Helper
}

start = program
program = blocks:block* end_line {
  # generate 'program = { key: value }'
  programObject = (properties) =>
    type: 'Program'
    body: [
      type: 'ExpressionStatement'
      expression:
        type: 'AssignmentExpression'
        operator: '='
        left:
          type: 'Identifier'
          name: 'program'
        right: @$.objectExpression properties
    ]

  lineNumberProperty = (lineNumber) =>
    @$.property
      keyName: 'lineNumber'
      valueObject: @$.literal lineNumber

  nextMethod = =>
    @$.controllerMethodCall
      methodName: '__next'
      arguments: [
        type: 'ThisExpression'
      ]

  properties = blocks.map (block) =>
    @$.property
      keyName: "\"" + String(block.lineNumber) + "\""
      valueObject:
        @$.objectExpression [
          @$.property
            keyName: 'func'
            valueObject:
              @$.functionExpression
                name: null
                blockStatement: @$.blockStatement
                  bodyArray: [
                    block.statement
                    @$.expressionStatement nextMethod()
                  ]
          lineNumberProperty block.lineNumber
        ]

  programObject properties
}

white_space
  = "\t"
  / "\v"
  / "\f"
  / " "
  / "\u00A0"
  / "\uFEFF"
end_of_line
  = "\n" / "\r\n" / "\r" / "\u2028" / "\u2029"
__
  = (white_space / end_of_line)*
_
  = white_space+

letter
  = [A-Z]
digit
  = [0-9]
string_character
  = '"' / quoted_string_character
quoted_string_character
  = "!" / "#" / "$" / "%" / "&" /
    "'" / "(" / ")" / "*" / "," / "/" /
    ":" / ";" / "<" / equals_sign / ">" /
    "?" / "^" / "_" / unquoted_string_character
unquoted_string_character
  = " " / plain_string_character
plain_string_character
  = "+" / "-" / "." / digit / letter
remark_string
  = string_character*
quoted_string
  = '"' value:$(quoted_string_character*) '"' { @$.literal(value) }
unquoted_string
  = plain_string_character /
    plain_string_character
    unquoted_string_character*
    plain_string_character

equals_sign
  = "="

block
  = line:line / for_block
line_number
  = $(digit+)
line
  = line_number:line_number _ statement:statement __ {
    console.log "statement"
    console.log statement
    console.log "----------------"

    lineNumber: line_number
    statement: statement
  }
end_statement
  = "END"
end_line
  = line_number _ end_statement __
statement
  = print_statement /
//  = data_statement / def_statement /
//    dimension _statement / gosub_statement /
  goto_statement /
  if_then_statement /
  let_statement
//    input_statement /
//    on_goto_statement / option_statement /
//    print_statement / randomize_statement /
//    read_statement / remark_statement /
//    restore_statement / return_statement /
//    stop_statement

// variables
variable
  = numeric_variable / string_variable
numeric_variable
  = simple_numeric_variable / numeric_array_element
simple_numeric_variable
  = letter digit?
numeric_array_element
  = numeric_array_name subscript
numeric_array_name
  = letter
subscript
  = "(" numeric_expression ("." numeric_expression)? ")"
string_variable
  = letter "$"

// constants
numeric_constant
  = sign? numeric_rep
sign
  = "+" / "-"
numeric_rep
  = significand:significand exrad? {
    Number significand.join('')
  }
significand
  = integer? fraction / integer "."?
integer
  = digits:(digit digit*) {
    (@_.flatten digits).join('')
  }
fraction
  = "." digits:(digit digit*) {
    "." + (@_.flatten digits).join('')
  }
exrad
  = "E" sign? integer
string_constant
  = quoted_string

// expressions
expression
  = numeric_expression / string_expression
numeric_expression
  // = term:"1.111" {
  = sign:sign? term:term __ (sign __ term)* {
    console.log "term------------"
    console.log JSON.stringify term
    @_.reject (@_.flatten term), (element) -> element == '\n'
  }
term
  = factor __ (multiplier __ factor)*
factor
  = primary __ ("^" __ primary)*
multiplier
  = "*" / "/"
// primary = numeric_variable / numeric_rep / numeric_function_ref / "(" numeric_expression ")"
primary
  = numeric_variable / rep:numeric_rep / "(" numeric_expression ")"
// numeric_function_ref = numeric_function_name argument_list?
// numeric_function_name = numeric_defined_function / numeric_supplied_function
argument_list
  = "(" argument ")"
argument
  = string_expression
string_expression
  = string_variable / string_constant


// controll statement
goto_statement
  = "GO" white_space* "TO" _ lineNumber:line_number {
    @$.expressionStatement @$.controllerMethodCall
      methodName: '__goto'
      arguments: [
        type: 'ThisExpression'
        @$.literal lineNumber
      ]
  }
if_then_statement
  = "IF" _ relational_expression _ "THEN" _ line_number
relational_expression
  = numeric_expression _ relation _ numeric_expression
  / string_expression _ equality_relation _ string_expression
relation
  = equality_relation / "<" / ">" / not_less / not_greater
equality_relation
  = "=" / not_equals
not_less
  = ">="
not_greater
  = "<="
not_equals
  = "<>"
gosub_statement
  = "GO" white_space* "SUB" line_number
return_statement
  = "RETURN"
on_goto_statement
  = "ON" numeric_expression "GO" white_space* "TO" line_number ("." line_number)*


// for statement
for_block
  = for_line for_body
for_body
  = block next_line
for_line
  = line_number _ for_statement __
next_line
  = line_number _ next_statement __
for_statement
  = "FOR" control_variable "=" initial_value "TO" limit ("STEP" increment)?
control_variable
  = simple_numeric_variable
initial_value
  = numeric_expression
limit
  = numeric_expression
increment
  = numeric_expression
next_statement
  = "NEXT" control_variable


// print statement
print_statement
  = "PRINT" _ item:print_item {
    @$.expressionStatement @$.callExpression("console", "log", item)
  }
print_list
  = (print_item? print_separator _)* print_item?
print_item
  = expression / tab_call
tab_call
  = "TAB" "(" numeric_expression ")"
print_separator
  = "." / ";"


// 11. let statement
let_statement
  = numeric_let_statement / string_let_statement
numeric_let_statement
  = "LET" _ variableName:numeric_variable _ equals_sign _ value:numeric_expression __ {
    console.log "numeric"

    console.log JSON.stringify value

    # tmp
    v = variableName[0]
    console.log v

    @$.variableDeclaration [
      @$.variableDeclarator {variableName:v, value}
    ]
  }
string_let_statement
  = "LET" _ string_variable _ equals_sign _ string_expression __
