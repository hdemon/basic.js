{
  @_ = require 'lodash'

  @programNode = (body) ->
    type: 'Program'
    body: body

  @property = (args) ->
    type: 'Property'
    key:
      type: 'Identifier'
      name: args.keyName
    value: args.valueObject
    kind: 'init'

  @programProperties = (blocks) =>
    blocks.map (block) =>
      @property
        keyName: "\"" + String(block.lineNumber) + "\""
        valueObject:
          @objectExpression [
            @property
              keyName: 'func'
              valueObject:
                @functionExpression
                  name: null
                  blockStatement: @blockStatement
                    bodyArray: [
                      block.expressionStatement
                      @expressionStatement @nextMethod()
                    ]
            @property
              keyName: 'lineNumber'
              valueObject: @literal block.lineNumber
          ]

  @programObject = (properties) =>
    type: 'Program'
    body: [
      type: 'ExpressionStatement'
      expression:
        type: 'AssignmentExpression'
        operator: '='
        left:
          type: 'Identifier'
          name: 'program'
        right: @objectExpression properties
    ]

  @controllerMethodCall = (args) ->
    type: 'CallExpression'
    callee:
      type: 'MemberExpression'
      computed: false
      object:
        type: 'MemberExpression'
        computed: false
        object:
          type: 'Identifier'
          name: 'controller'
        property:
          type: 'Identifier'
          name: args.methodName
      property:
        type: 'Identifier'
        name: 'call'
    arguments: args.arguments

  @nextMethod = =>
    @controllerMethodCall
      methodName: '__next'
      arguments: [
        type: 'ThisExpression'
      ]

  @gotoMethod = (lineNumber) =>
    @controllerMethodCall
      methodName: '__goto'
      arguments: [
        type: 'ThisExpression'
        @literal lineNumber
      ]

  @blockStatement = (args) ->
    type: 'BlockStatement'
    body: args.bodyArray

  @expressionStatement = (expressionObject) ->
    type: 'ExpressionStatement'
    expression: expressionObject

  @objectExpression = (propertyArray) ->
    type: 'ObjectExpression'
    properties: propertyArray

  @callExpression = (objectName, propertyName, argumentsObject) ->
    type: 'CallExpression'
    callee:
      type: 'MemberExpression'
      computed: false
      object:
        type: 'Identifier'
        name: objectName
      property:
        type: 'Identifier'
        name: propertyName
    arguments: [
      argumentsObject
    ]

  @functionExpression = (args) ->
    type: 'FunctionExpression'
    id: args.name || null
    params: []
    defaults: []
    body: args.blockStatement
    rest: null
    generator:  false
    expression: false

  @functionDeclaration = (name, blockStatement) ->
    type: "FunctionDeclaration"
    id:
      type: "Identifier"
      name: name
    params: []
    defaults: []
    body: blockStatement
    rest: null
    generator: false
    expression: false

  @literal = (value) ->
    type: 'Literal'
    value: value

  @ifThenStatement = (args) =>
    type: 'IfStatement'
    test:
      type: 'BinaryExpression'
      operator: args.operator
      left: args.left
      right: args.right
    consequent:
      type: 'ExpressionStatement'
      expression: args.callExpression
    alternate: null
}


start = program
program = blocks:block* end_line {
  @programObject @programProperties blocks
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
    ":" / ";" / "<" / "=" / ">" /
    "?" / "^" / "_" / unquoted_string_character
unquoted_string_character
  = " " / plain_string_character
plain_string_character
  = "+" / "-" / "." / digit / letter
remark_string
  = string_character*
quoted_string
  = '"' value:$(quoted_string_character*) '"' { @literal(value) }
unquoted_string
  = plain_string_character /
    plain_string_character
    unquoted_string_character*
    plain_string_character

block
  = line:line / for_block
line_number
  = $(digit+)
line
  = line_number:line_number _ statement:statement __ {
    lineNumber: line_number
    expressionStatement: @expressionStatement(statement)
  }
end_statement
  = "END"
end_line
  = line_number _ end_statement __
statement
  = print_statement /
//  = data_statement / def_statement /
//    dimension _statement / gosub_statement /
  goto_statement / if_then_statement
//    input_statement / let_statement /
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
  = significand exrad?
significand
  = integer "."? / integer? fraction
integer
  = digit digit*
fraction
  = "." digit digit*
exrad
  = "E" sign? integer
string_constant   = quoted_string

// expressions
expression
  = numeric_expression / string_expression
numeric_expression
  = sign? term (sign term)*
term
  = factor (multiplier factor)*
factor
  = primary ("^" primary)*
multiplier
  = "*" / "/"
// primary = numeric_variable / numeric_rep / numeric_function_ref / "(" numeric_expression ")"
primary
  = numeric_variable / numeric_rep / "(" numeric_expression ")"
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
    @gotoMethod lineNumber
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
    @callExpression("console", "log", item)
  }
print_list
  = (print_item? print_separator _)* print_item?
print_item
  = expression / tab_call
tab_call
  = "TAB" "(" numeric_expression ")"
print_separator
  = "." / ";"
