{
  @_ = require 'lodash'

  @programNode = (body) ->
    type: 'Program'
    body: body

  @blockStatement = (bodyArray) ->
    type: 'BlockStatement'
    body: bodyArray

  @expressionStatement = (expressionObject) ->
    type: 'ExpressionStatement'
    expression: expressionObject

  @objectExpression = (propertyArray) ->
    type: 'ObjectExpression'
    properties: propertyArray

  @property = (args) ->
    type: 'Property'
    key:
      type: 'Identifier'
      name: args.keyName
    value: args.valueObject
    kind: 'init'

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

  @functionExpression = (args) ->
    type: 'FunctionExpression'
    id: args.name || null
    params: []
    defaults: []
    body: args.blockStatement
    rest: null
    generator:  false
    expression: false

  @literal = (value) ->
    type: 'Literal'
    value: value

  # program.__next.call(this);
  #
  # todo: DRYed up
  @__next =
    @expressionStatement
      type: 'CallExpression'
      callee:
        type: 'MemberExpression'
        computed: false
        object:
          type: 'MemberExpression'
          computed: false
          object:
            type: 'Identifier'
            name: 'program'
          property:
            type: 'Identifier'
            name: '__next'
        property:
          type: 'Identifier'
          name: 'call'
      arguments: [
        type: 'ThisExpression'
      ]

  @program = (properties) =>
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
}


start = program
program = blocks:block* end_line {
  body = blocks.map (block) =>
    @property
      keyName: "\"" + String(block.lineNumber) + "\""
      valueObject:
        @functionExpression
          name: null
          blockStatement: @blockStatement [
            block.expressionStatement
            @__next
          ]

  @program body
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
unquoted_string_character = " " / plain_string_character
plain_string_character    = "+" / "-" / "." / digit / letter
remark_string             = string_character*
quoted_string             = '"' value:$(quoted_string_character*) '"' { @literal(value) }
unquoted_string           = plain_string_character /
                            plain_string_character
                            unquoted_string_character*
                            plain_string_character

block            = line:line / for_block
line             = line_number:line_number _ statement:statement __ {
  lineNumber: line_number
  expressionStatement: @expressionStatement(statement)
}
//line             = line_number:line_number
line_number      = $(digit+)
end_line         = line_number _ end_statement __
end_statement    = "END"
statement        = print_statement
//  = data_statement / def_statement /
//    dimension _statement / gosub_statement /
//    goto_statement / if_then_statement /
//    input_statement / let_statement /
//    on_goto_statement / option_statement /
//    print_statement / randomize_statement /
//    read_statement / remark_statement /
//    restore_statement / return_statement /
//    stop_statement

// variables
variable               = numeric_variable / string_variable
numeric_variable       = simple_numeric_variable / numeric_array_element
simple_numeric_variable= letter digit?
numeric_array_element  = numeric_array_name subscript
numeric_array_name     = letter
subscript              = "(" numeric_expression ("." numeric_expression)? ")"
string_variable        = letter "$"

// constants
numeric_constant  = sign? numeric_rep
sign              = "+" / "-"
numeric_rep       = significand exrad?
significand       = integer "."? / integer? fraction
integer           = digit digit*
fraction          = "." digit digit*
exrad             = "E" sign? integer
string_constant   = quoted_string

// expressions
expression         = numeric_expression / string_expression
numeric_expression = sign? term (sign term)*
term               = factor (multiplier factor)*
factor             = primary ("^" primary)*
multiplier         = "*" / "/"
// primary            = numeric_variable / numeric_rep / numeric_function_ref / "(" numeric_expression ")"
primary            = numeric_variable / numeric_rep / "(" numeric_expression ")"
// numeric_function_ref  = numeric_function_name argument_list?
// numeric_function_name  = numeric_defined_function / numeric_supplied_function
argument_list      = "(" argument ")"
argument           = string_expression
string_expression  = string_variable / string_constant

// for statement
for_block                = for_line for_body
for_body                 = block next_line
for_line                 = line_number _ for_statement __
next_line                = line_number _ next_statement __
for_statement            = "FOR" control_variable "=" initial_value "TO" limit ("STEP" increment)?
control_variable         = simple_numeric_variable
initial_value            = numeric_expression
limit                    = numeric_expression
increment                = numeric_expression
next_statement           = "NEXT" control_variable

// print statement
print_statement       = "PRINT" _ item:print_item {
  @callExpression("console", "log", item)
}
//print_statement       = "PRINT" _ list:print_list?
print_list            = (print_item? print_separator _)* print_item?
print_item            = expression // / tab_call
// tab_call              = "TAB" "(" numeric_expression ")"
print_separator       = "." / ";"