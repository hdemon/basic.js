// constants
numeric_constant
  = sign:sign? numeric_rep:numeric_rep {
    if (sign) {
      return `${sign}${numeric_rep}`
    } else {
      return `${numeric_rep}`
    }
  }

sign
  = plus_sign / minus_sign

numeric_rep
  = significand:significand exrad:exrad? {
    let raw = significand.join('')
    if (exrad) { raw += exrad.join('') }

    return raw
    // return {
    //   type: "Literal",
    //   value: Number(raw),
    //   raw,
    // }
  }

significand
  = integer? fraction / integer full_stop?

integer
  = digits:(digit digit*) {
    return (_.flatten(digits)).join('')
  }

fraction
  = full_stop digits:(digit digit*) {
    return "." + (_.flatten(digits)).join('')
  }

exrad
  = E sign? integer

string_constant
  = quoted_string

E =
  "E"
