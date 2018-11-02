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

string_character
  = quotation_mark / quoted_string_character

quoted_string_character
  = exclamation_mark / number_sign / dollar_sign / percent_sign / ampersand /
    "'" / left_parenthesis / right_parenthesis / asterisk / comma / solidus /
    colon / semi_colon / less_than_sign / equals_sign / greater_than_sign /
    question_mark / circumflex_accent / underline / unquoted_string_character
  // = "!" / "#" / "$" / "%" / "&" /
  //   "'" / "(" / ")" / "*" / "," / "/" /
  //   ":" / ";" / "<" / "=" / ">" /
  //   "?" / "^" / "_" / unquoted_string_character

unquoted_string_character
  = white_space / plain_string_character

plain_string_character
  = plus_sign / minus_sign / full_stop / digit / letter

remark_string
  = string_character*

quoted_string
  = quotation_mark value:$(quoted_string_character*) quotation_mark {
      return value;
    //   return  $.literal(value)
    }

unquoted_string
  = plain_string_character /
    plain_string_character
    unquoted_string_character*
    plain_string_character
