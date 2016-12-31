#!/usr/bin/env coffee

mkElt = (tagName, props) ->
	elt = document.createElement tagName
	for property, value of props
		elt[property] = value
	return elt

numMatches = (word1, word2) ->
	same = 0
	len = Math.min word1.length, word2.length
	for i in [0 ... len]
		++same if word1.charAt(i) is word2.charAt(i)
	return same

numKeys = (hash) -> Object.keys(hash).length

class MatchTable
	constructor: (@words) ->

		@matchTable = {}
		for source in [0 ... @words.length]
			for target in [source+1 ... @words.length]
				matches = numMatches @words[source], @words[target]

				@alloc @words[source], matches
				@alloc @words[target], matches

				@matchTable[@words[source]][matches].push @words[target]
				@matchTable[@words[target]][matches].push @words[source]

	alloc: (index, matches) ->
		return unless index?
		@matchTable[index] = {} unless @matchTable[index]?
		return unless matches?
		@matchTable[index][matches] = [] unless @matchTable[index][matches]?

	addButtonClick: (button, wordList) ->
		button.addEventListener 'click', ->
			solvePuzzle wordList

	wordsToTry: ->
		# Sort messes up 'this', so we need global or local variables
		matchTable = @matchTable
		return @words.sort (a, b) ->
			if numKeys(matchTable[a]) > numKeys(matchTable[b])
				-1
			else if numKeys(matchTable[a]) < numKeys(matchTable[b])
				1
			else
				0

	toElt: ->
		elt = mkElt 'table',
			className: 'matchTable'

		headerRow = mkElt 'tr'
		headerRow.appendChild mkElt('th',
			innerHTML: 'Word')
		headerRow.appendChild mkElt('th',
			innerHTML: 'Likeness')
		headerRow.appendChild mkElt('th',
			innerHTML: 'Compatible Words')
		elt.appendChild headerRow

		for word in @wordsToTry()
			others = @matchTable[word]
			wordRowCount = 0

			for rating, wordList of others
				row = mkElt 'tr'

				if wordRowCount is 0
					row.classList.add 'newWord'
					row.appendChild mkElt('td',
						innerHTML:	word
						rowSpan:	Object.keys(others).length)
					++wordRowCount

				ratingCell = mkElt 'td',
					className:	'ratingCell'
				if wordList.length > 1
					ratingButton = mkElt 'button',
						innerHTML:	rating
					@addButtonClick ratingButton, wordList
					ratingCell.appendChild ratingButton
				else
					ratingCell.innerHTML = rating
				row.appendChild ratingCell

				otherCell = mkElt 'td'
				for other in wordList
					otherCell.appendChild mkElt('span',
						innerHTML:	other + ' ')
				row.appendChild otherCell

				elt.appendChild row

		# Add a row with a reset button so you can get back to the initial state
		lastRow = mkElt 'tr',
			className: 'newWord'
		lastRow.appendChild mkElt 'td'
		resetCell = mkElt 'td',
			className: 'ratingCell'
		resetButton = mkElt 'button',
			innerHTML: 'Reset'
		resetButton.addEventListener 'click', (event) ->
			input = document.getElementById 'input'
			words = input.value.trim().split /\W+/
			solvePuzzle words
		resetCell.appendChild resetButton
		lastRow.appendChild resetCell
		lastRow.appendChild mkElt 'td'
		elt.appendChild lastRow

		return elt

solvePuzzle = (words) ->
	myTable = new MatchTable words
	output = document.getElementById 'output'
	output.innerHTML = ''
	output.appendChild myTable.toElt()

window?.addEventListener 'load', ->
	input = document.getElementById 'input'
	input?.addEventListener 'input', (event) ->
		inputStr = event.target.value
		words = inputStr.trim().split /\W+/
		solvePuzzle words
