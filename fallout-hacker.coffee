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

listLengthSummary = (hash) -> (words.length for likeness, words of hash).sort()

# The better option has shorter word lists, or fewer long ones.
likenessCompare = (hash1, hash2) ->
	summary1 = listLengthSummary hash1
	summary2 = listLengthSummary hash2
	while summary1.length > 0 and summary2.length > 0
		first1 = summary1.pop()
		first2 = summary2.pop()
		if first1 < first2
			return -1
		else if first2 < first1
			return 1
	return 0

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
		return @words.sort (a, b) -> likenessCompare matchTable[a], matchTable[b]

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

			for likeness, wordList of others
				row = mkElt 'tr'

				if wordRowCount is 0
					row.classList.add 'newWord'
					row.appendChild mkElt('td',
						innerHTML:	word
						rowSpan:	numKeys others)
					++wordRowCount

				likenessCell = mkElt 'td',
					className:	'likenessCell'
				if wordList.length > 1
					likenessButton = mkElt 'button',
						innerHTML:	likeness
					@addButtonClick likenessButton, wordList
					likenessCell.appendChild likenessButton
				else
					likenessCell.innerHTML = likeness
				row.appendChild likenessCell

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
			className: 'likenessCell'
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
