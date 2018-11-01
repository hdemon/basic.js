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
