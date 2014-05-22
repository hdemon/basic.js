start = Program
Symbol = $([a-zA-Z] [a-zA-Z0-9]*)
//Symbol = [-+*/!@%^&=a-zA-Z0-9_]*
Number = $(("+" / "-")? _ [1-9] [0-9]* ("." [0-9]+)? )
WhiteSpace "whitespace"
  = "\t"
  / "\v"
  / "\f"
  / " "
  / "\u00A0"
  / "\uFEFF"
LineTerminatorSequence "end of line"
  = "\n"
  / "\r\n"
  / "\r"
  / "\u2028"
  / "\u2029"
__
  = (WhiteSpace / LineTerminatorSequence)*
_
  = WhiteSpace*


Program =
  Poem

/**********************

I believe that the time is ripe for signiﬁcantly better documentation of programs, and that we can best achieve this by considering programs to be works of literature.

Donald E. Knuth

**********************/

Poem =
  Stanza+

Stanza =
  row:Row+

Row =
  CorrectOrderSentence __
  / Anastrophe __

CorrectOrderSentence =
  ConditionSentence "," __ OutputSentence "."

Anastrophe =
  OutputSentence "," __ ConditionSentence "."

ConditionSentence =
  Sentence
  //Sentence* condition:(Subject ComparativeSentence Symbol) Sentence? { return {}; }

OutputSentence =
  Sentence* ("'" output:Sentence) { return {output:output}; }

Sentence =
  (Word _?)+

Word =
  Subject
  / symbol:Symbol { return symbol; }

ComparativeSentence =
  "%"


Subject =
  subject:(
    "I"
    / "You" / "you" / "thou"
    // / "We" / "we"
    // / "He" / "he"
    // / "She" / "she"
  ) {
    return { subject: subject };
  }


/*
BooleanLiteral
  = TrueToken  { return { type: "Literal", value: true  }; }
  / FalseToken { return { type: "Literal", value: false }; }
*/
/*
 * The "!(IdentifierStart / DecimalDigit)" predicate is not part of the official
 * grammar, it comes from text in section 7.8.3.
 */
 /*
NumericLiteral "number"
  = literal:DecimalLiteral !(IdentifierStart / DecimalDigit) {
      return literal;
    }

DecimalLiteral
  = DecimalIntegerLiteral "." DecimalDigit* {
      return { type: "Literal", value: parseFloat(text()) };
    }
  / "." DecimalDigit+ {
      return { type: "Literal", value: parseFloat(text()) };
    }
  / DecimalIntegerLiteral {
      return { type: "Literal", value: parseFloat(text()) };
    }

DecimalIntegerLiteral
  = "0"
  / NonZeroDigit DecimalDigit*

DecimalDigit
  = [0-9]

NonZeroDigit
  = [1-9]

ExponentPart
  = ExponentIndicator SignedInteger

ExponentIndicator
  = "e"i

SignedInteger
  = [+-]? DecimalDigit+
*/