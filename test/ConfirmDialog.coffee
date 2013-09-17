Dialog = require 'Dialog'
Confirm = require 'ConfirmDialog'
Overlay = require 'overlay'
Q = require 'q'

Q.stopUnhandledRejectionTracking()

dialog = null


describe 'ConfirmDialog', ->

	beforeEach( ->
		dialog = new Confirm
	)

	afterEach( ->
		if Overlay.el
			Overlay.el.remove()
			Overlay.el = null

		if dialog.el
			dialog.el.remove()
			dialog.el = null

		Overlay.visible = false
		Dialog.visible = null
		Dialog.closing = false
	)

	describe '#constructor()', ->
		it 'should create base two buttons', ->
			expect(dialog.buttons.length).to.be.equal(2)

	describe '#onTrue()', ->
		it 'should call this method when ok button is clicked', (done) ->
			dialog.onTrue( -> done() )
			dialog.show().then( ->
				button = $(dialog.el).find('div.buttons a:nth-child(1)')
				button.click()
			).done()

	describe '#onFalse()', ->
		it 'should call this method when cancel button is clicked', (done) ->
			dialog.onFalse( -> done() )
			dialog.show().then( ->
				button = $(dialog.el).find('div.buttons a:nth-child(2)')
				button.click()
			).done()