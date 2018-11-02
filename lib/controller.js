controller.__next = function() {
  var lineIndexes = controller.__getLineIndexes();
  var currentLineIndex = lineIndexes.indexOf(String(this.lineNumber));
  var nextLineNumber = lineIndexes[currentLineIndex + 1];
  if (nextLineNumber) {
    program[String(nextLineNumber)].func();
  }
};

controller.__goto = function(lineNumber) {
  program[String(lineNumber)].func();
};

controller.__getLineIndexes = function(lineNumber) {
  var lineIndexes = Object.keys(program)
  return lineIndexes.sort(function (a, b) {
      return (
        program[b].hoisted - program[a].hoisted
        || parseInt(program[a].lineNumber) - parseInt(program[b].lineNumber)
      );
  });
};

controller.__start = function() {
  var lineIndexes = controller.__getLineIndexes();
  program[String(lineIndexes[0])].func();
};

controller.__start();
