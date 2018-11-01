
expression
  = string_expression / numeric_expression
numeric_expression
  = sign:sign? leftTerm:term _ rightTerms:(sign _ term)* {
    _rightTerms = @_.map rightTerms, (term) =>
      operator: @_.first term
      value: @_.last term

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
