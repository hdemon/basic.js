expression
  = string_expression / numeric_expression

numeric_expression
  = sign:sign? leftTerm:term _ rightTerms:(sign _ term)* {
    const _rightTerms = _.map(rightTerms, (term) => {
      return {
        operator: _.first(term),
        value: _.last(term)
      }
    })

    if (_.isEmpty(rightTerms)) {
      return leftTerm
    } else {
      return buildBinaryExpressionRecursively({
        left: leftTerm,
        rights: _rightTerms.reverse()
      })
    }
  }

term
  = factor:factor _ tail:(multiplier _ factor)* {
    const _tail = _.map(tail, (term) => {
      return {
        operator: _.first(term),
        value: _.last(term)
      }
    })

    if (_.isEmpty(tail)){
      return factor
    } else {
      return buildBinaryExpressionRecursively({
        left: factor,
        rights: _tail.reverse()
      })
    }
  }

factor
  = primary:primary _ tail:(_ circumflex_accent _ primary)* {
    const buildCallExpressionRecursively = (firstExpression, _tail) => {
      const term = _tail.pop()
      const value = _.last(term)

      const expression = $.callExpression({
        object: 'Math',
        property: 'pow',
        args: [
          firstExpression,
          value,
        ],
      })

      if (tail.length <= 0) {
        return expression
      } else {
        return buildCallExpressionRecursively(expression, _tail)
      }
    }

    if (_.isEmpty(tail)) {
      return primary
    } else {
      return buildCallExpressionRecursively(primary, tail.reverse())
    }
  }

multiplier
  = asterisk / solidus

primary
  // The original order is numeric-variable, rep, function_ref. But under PEG we should prior numeric_function_ref
  // because the parser will 
  = numeric_function_ref /
    numeric_variable /
    numeric_rep /
    left_parenthesis expression:numeric_expression right_parenthesis { return expression }

numeric_function_ref
  = name:numeric_function_name _args:argument_list?

numeric_function_name
  = numeric_defined_function /
    numeric_supplied_function

argument_list
  = left_parenthesis argument:argument right_parenthesis { return argument }

argument
  = numeric_expression

string_expression
  = string_variable / string_constant
