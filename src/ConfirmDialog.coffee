Dialog = require './Dialog'

class ConfirmDialog extends Dialog


	@trueText = 'OK'

	@falseText = 'Cancel'

	trueText: null

	falseText: null


	constructor: (jquery, @content, @trueText = ConfirmDialog.trueText, @falseText = ConfirmDialog.falseText) ->
		super(jquery)

		@addButton(@trueText, => @emit 'true', @)
		@addButton(@falseText, => @emit 'false', @)


module.exports = ConfirmDialog