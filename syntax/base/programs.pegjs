start = program

program = blocks:block* endLine:end_line {
  return blocks
}

block
  = line:line / for_block

line_number
  = number:$(digit+) { return Number(number) }

line
  = line_number:line_number _ statement:statement __ {
    return { line_number, ...statement }
  }

end_statement
  = END

end_line
  = lineNumber:line_number _ statement:end_statement __ {
    return { lineNumber, ...statement }
  }

statement
  = print_statement /
//  = data_statement / def_statement /
//    dimension _statement / gosub_statement /
  goto_statement /
  if_then_statement /
  let_statement /
  data_statement /
  read_statement
//    input_statement /
//    on_goto_statement / option_statement /
//    print_statement / randomize_statement /
//    read_statement / remark_statement /
//    restore_statement / return_statement /
//    stop_statement
// expressions

END =
  "END"
