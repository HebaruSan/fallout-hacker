// Generated by CoffeeScript 1.9.3
(function() {
  var MatchTable, mkElt, numKeys, numMatches, solvePuzzle;

  mkElt = function(tagName, props) {
    var elt, property, value;
    elt = document.createElement(tagName);
    for (property in props) {
      value = props[property];
      elt[property] = value;
    }
    return elt;
  };

  numMatches = function(word1, word2) {
    var i, j, len, ref, same;
    same = 0;
    len = Math.min(word1.length, word2.length);
    for (i = j = 0, ref = len; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
      if (word1.charAt(i) === word2.charAt(i)) {
        ++same;
      }
    }
    return same;
  };

  numKeys = function(hash) {
    return Object.keys(hash).length;
  };

  MatchTable = (function() {
    function MatchTable(words1) {
      var j, k, matches, ref, ref1, ref2, source, target;
      this.words = words1;
      this.matchTable = {};
      for (source = j = 0, ref = this.words.length; 0 <= ref ? j < ref : j > ref; source = 0 <= ref ? ++j : --j) {
        for (target = k = ref1 = source + 1, ref2 = this.words.length; ref1 <= ref2 ? k < ref2 : k > ref2; target = ref1 <= ref2 ? ++k : --k) {
          matches = numMatches(this.words[source], this.words[target]);
          this.alloc(this.words[source], matches);
          this.alloc(this.words[target], matches);
          this.matchTable[this.words[source]][matches].push(this.words[target]);
          this.matchTable[this.words[target]][matches].push(this.words[source]);
        }
      }
    }

    MatchTable.prototype.alloc = function(index, matches) {
      if (index == null) {
        return;
      }
      if (this.matchTable[index] == null) {
        this.matchTable[index] = {};
      }
      if (matches == null) {
        return;
      }
      if (this.matchTable[index][matches] == null) {
        return this.matchTable[index][matches] = [];
      }
    };

    MatchTable.prototype.addButtonClick = function(button, wordList) {
      return button.addEventListener('click', function() {
        return solvePuzzle(wordList);
      });
    };

    MatchTable.prototype.wordsToTry = function() {
      var matchTable;
      matchTable = this.matchTable;
      return this.words.sort(function(a, b) {
        if (numKeys(matchTable[a]) > numKeys(matchTable[b])) {
          return -1;
        } else if (numKeys(matchTable[a]) < numKeys(matchTable[b])) {
          return 1;
        } else {
          return 0;
        }
      });
    };

    MatchTable.prototype.toElt = function() {
      var elt, headerRow, j, k, lastRow, len1, len2, other, otherCell, others, rating, ratingButton, ratingCell, ref, resetButton, resetCell, row, word, wordList, wordRowCount;
      elt = mkElt('table', {
        className: 'matchTable'
      });
      headerRow = mkElt('tr');
      headerRow.appendChild(mkElt('th', {
        innerHTML: 'Word'
      }));
      headerRow.appendChild(mkElt('th', {
        innerHTML: 'Similarity'
      }));
      headerRow.appendChild(mkElt('th', {
        innerHTML: 'Compatible Words'
      }));
      elt.appendChild(headerRow);
      ref = this.wordsToTry();
      for (j = 0, len1 = ref.length; j < len1; j++) {
        word = ref[j];
        others = this.matchTable[word];
        wordRowCount = 0;
        for (rating in others) {
          wordList = others[rating];
          row = mkElt('tr');
          if (wordRowCount === 0) {
            row.classList.add('newWord');
            row.appendChild(mkElt('td', {
              innerHTML: word,
              rowSpan: Object.keys(others).length
            }));
            ++wordRowCount;
          }
          ratingCell = mkElt('td', {
            className: 'ratingCell'
          });
          if (wordList.length > 1) {
            ratingButton = mkElt('button', {
              innerHTML: rating
            });
            this.addButtonClick(ratingButton, wordList);
            ratingCell.appendChild(ratingButton);
          } else {
            ratingCell.innerHTML = rating;
          }
          row.appendChild(ratingCell);
          otherCell = mkElt('td');
          for (k = 0, len2 = wordList.length; k < len2; k++) {
            other = wordList[k];
            otherCell.appendChild(mkElt('span', {
              innerHTML: other + ' '
            }));
          }
          row.appendChild(otherCell);
          elt.appendChild(row);
        }
      }
      lastRow = mkElt('tr', {
        className: 'newWord'
      });
      lastRow.appendChild(mkElt('td'));
      resetCell = mkElt('td', {
        className: 'ratingCell'
      });
      resetButton = mkElt('button', {
        innerHTML: 'Reset'
      });
      resetButton.addEventListener('click', function(event) {
        var input, words;
        input = document.getElementById('input');
        words = input.value.trim().split(/\W+/);
        return solvePuzzle(words);
      });
      resetCell.appendChild(resetButton);
      lastRow.appendChild(resetCell);
      lastRow.appendChild(mkElt('td'));
      elt.appendChild(lastRow);
      return elt;
    };

    return MatchTable;

  })();

  solvePuzzle = function(words) {
    var myTable, output;
    myTable = new MatchTable(words);
    output = document.getElementById('output');
    output.innerHTML = '';
    return output.appendChild(myTable.toElt());
  };

  if (typeof window !== "undefined" && window !== null) {
    window.addEventListener('load', function() {
      var input;
      input = document.getElementById('input');
      return input != null ? input.addEventListener('input', function(event) {
        var inputStr, words;
        inputStr = event.target.value;
        words = inputStr.trim().split(/\W+/);
        return solvePuzzle(words);
      }) : void 0;
    });
  }

}).call(this);
