var controller = {};
var global = {};
var program = {};
program = {
    "10": {
        func: function () {
            global.A = 1;
            controller.__next.call(this);
        },
        lineNumber: 10
    },
    "20": {
        func: function () {
            global.A = global.A + 1;
            controller.__next.call(this);
        },
        lineNumber: 20
    },
    "30": {
        func: function () {
            console.log(global.A);
            controller.__next.call(this);
        },
        lineNumber: 30
    },
    "40": {
        func: function () {
            if (global.A !== 10)
                controller.__goto.call(this, 20);
            controller.__next.call(this);
        },
        lineNumber: 40
    },
    "999": {
        func: function () {
        },
        lineNumber: 999
    }
};controller.__next = function() {
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

