Dialog = require './Dialog'

class ConfirmDialog extends Dialog


	@trueText = 'OK'

	@falseText = 'Cancel'

	trueText: null

	falseText: null


	constructor: (jquery, @content, @trueText = ConfirmDialog.trueText, @falseText = ConfirmDialog.falseText) ->
		super(jquery)

		@addButton(@trueText, null)
		@addButton(@falseText, null)


	onTrue: (fn) ->
		for button in @buttons
			if button.title == @trueText
				button.action = fn
				break


	onFalse: (fn) ->
		for button in @buttons
			if button.title == @falseText
				button.action = fn
				break


module.exports = ConfirmDialog