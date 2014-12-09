{
  @_ = require 'lodash'
  @esvalid = require "esvalid"
  @pj = require 'prettyjson'
  require 'colors';

  Builder = require process.cwd() + '/lib/builder'
  @$ = new Builder
}

start = program
program = blocks:block* endLine:end_line {
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

    @$.property
  properties = @_.map blocks, (block) =>
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

  endProperties = =>
    @$.property
      keyName: "\"" + String(endLine.lineNumber) + "\""
      valueObject:
        @$.objectExpression [
          @$.property
            keyName: 'func'
            valueObject:
              @$.functionExpression
                name: null
                blockStatement: @$.blockStatement
                  bodyArray: []
          lineNumberProperty endLine.lineNumber
        ]

  ast = programObject (properties.concat endProperties())

  unless @esvalid.isValid ast
    @_.each (@esvalid.errors ast), (error) =>
      console.error "error: ".red + error.message
      console.error "error: ".red + @pj.render(error.node)
      console.error "\r"

  ast
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
  = (white_space / end_of_line)* { " " }
_
  = white_space* { " " }

letter
  = [A-Z]
digit
  = [0-9]
string_character
  = '"' / quoted_string_character
quoted_string_character
  = "!" / "#" / "$" / "%" / "&" /
    "'" / "(" / ")" / "*" / "," / "/" /
    ":" / ";" / "<" / "=" / ">" /
    "?" / "^" / "_" / unquoted_string_character
unquoted_string_character
  = " " / plain_string_character
plain_string_character
  = "+" / "-" / "." / digit / letter
remark_string
  = string_character*
quoted_string
  = "\"" value:$(quoted_string_character*) "\"" { @$.literal(value) }
unquoted_string
  = plain_string_character /
    plain_string_character
    unquoted_string_character*
    plain_string_character

block
  = line:line / for_block
line_number
  = number:$(digit+) { Number number }
line
  = line_number:line_number _ statement:statement __ {
    lineNumber: line_number
    statement: statement
  }
end_statement
  = "END" {
    @$.expressionStatement @$.functionExpression
      blockStatement: @$.blockStatement
        bodyArray: []
  }
end_line
  = lineNumber:line_number _ statement:end_statement __ {
    {lineNumber, statement}
  }
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
  // = variableName:simple_numeric_variable / numeric_array_element {
  = simple_numeric_variable
simple_numeric_variable
  = letter:letter digits:digit? {
    name = letter
    name += digits.join('') if digits
    @$.variableExpression name
  }
numeric_array_element
  = numeric_array_name subscript
numeric_array_name
  = letter
subscript
  = "(" numeric_expression ("." numeric_expression)? ")"
string_variable
  = letter:letter "$" {
    @$.variableExpression(letter + "$")
  }

// constants
numeric_constant
  = sign? numeric_rep
sign
  = "+" / "-"
numeric_rep
  = significand:significand exrad:exrad? {
    raw = significand.join('')
    if exrad then raw += exrad.join('')

    type: "Literal"
    value: Number raw
    raw: raw
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
  = string_expression / numeric_expression
numeric_expression
  = sign:sign? leftTerm:term _ rightTerms:(sign _ term)* {
    _rightTerms = @_.map rightTerms, (term) =>
      operator: @_.first term
      value: @_.last term

    console.log "numeric rightTerms ---"
    console.log rightTerms
    console.log "numeric leftTerms ---"
    console.log leftTerm
    if @_.isEmpty rightTerms
      leftTerm
    else
      @$.buildBinaryExpressionRecursively
        left: leftTerm,
        rights: _rightTerms.reverse()
  }
term
  = factor:factor _ tail:(multiplier _ factor)* {
    _tail = @_.map tail, (term) =>
      operator: @_.first term
      value: @_.last term

    if @_.isEmpty tail
      factor
    else
      @$.buildBinaryExpressionRecursively
        left: factor,
        rights: _tail.reverse()
  }
factor
  = primary:primary _ tail:(_ "^" _ primary)* {
    buildCallExpressionRecursively = (firstExpression, _tail) =>
      term = _tail.pop()
      value = @_.last term

      expression = @$.callExpression
        object: 'Math'
        property: 'pow'
        args: [
          firstExpression
          value
        ]

      if tail.length <= 0
        expression
      else
        buildCallExpressionRecursively expression, _tail

    if @_.isEmpty tail
      primary
    else
      buildCallExpressionRecursively primary, tail.reverse()
  }
multiplier
  = "*" / "/"
// primary = numeric_variable / numeric_rep / numeric_function_ref / "(" numeric_expression ")"
primary
  = variable:numeric_variable / rep:numeric_rep / "(" expression:numeric_expression ")"
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
  = "GO" _ "TO" _ lineNumber:line_number {
    @$.expressionStatement @$.callGotoExpression lineNumber
  }
if_then_statement
  = "IF" _ testExpression:relational_expression _ "THEN" _ lineNumber:line_number {
    # test expression is identifier or binary expression
    @$.ifStatement {testExpression, lineNumber}
  }
relational_expression
  = left:numeric_expression _ operator:relation _ right:numeric_expression {
      @$.binaryExpression {left, right, operator}
    }
relation
  = equality_relation / "<" / ">" / not_less / not_greater
equality_relation
  = equals / not_equals
equals
  = "=" { "==" }
not_less
  = ">="
not_greater
  = "<="
not_equals
  = "<>" { "!==" }
gosub_statement
  = "GO" _ "SUB" line_number
return_statement
  = "RETURN"
on_goto_statement
  = "ON" numeric_expression "GO" _ "TO" line_number ("." line_number)*


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


// 11. let statement
let_statement
  = numeric_let_statement / string_let_statement
numeric_let_statement
  = "LET" _ variableExpression:numeric_variable _ "=" _ expression:numeric_expression __ {
    @$.assignToVariable {variableExpression, expression}
  }
string_let_statement
  = "LET" _ variableExpression:string_variable _ "=" _ expression:string_expression __ {
    @$.assignToVariable {variableExpression, expression}
  }
