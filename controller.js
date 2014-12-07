var controller = {};
var global = {};
var program = {};

controller.__next = function() {
  var lineIndexes = Object.keys(program);
  var currentLineIndex = lineIndexes.indexOf(String(this.lineNumber));
  var nextLineNumber = lineIndexes[currentLineIndex + 1];
  if (nextLineNumber) {
    program[String(nextLineNumber)].func();
  }
};

controller.__goto = function(lineNumber) {
  program[String(lineNumber)].func();
};

controller.__start = function() {
  var lineIndexes = Object.keys(program);
  program[String(lineIndexes[0])].func();
};

controller.__start();
