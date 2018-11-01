// constants
numeric_constant
  = sign? numeric_rep
sign
  = "+" / "-"
numeric_rep
  = significand:significand exrad:exrad? {
    let raw = significand.join('')
    if (exrad) { raw += exrad.join('') }

    return {
      type: "Literal",
      value: Number(raw),
      raw,
    }
  }
significand
  = integer? fraction / integer "."?
integer
  = digits:(digit digit*) {
    return (_.flatten(digits)).join('')
  }
fraction
  = "." digits:(digit digit*) {
    return "." + (_.flatten(digits)).join('')
  }
exrad
  = "E" sign? integer
string_constant
  = quoted_string
