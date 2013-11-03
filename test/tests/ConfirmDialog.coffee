Dialog = require 'Dialog'
Confirm = require 'ConfirmDialog'
Overlay = require 'overlay'
Q = require 'q'

$ = window.jQuery
dialog = null


describe 'ConfirmDialog', ->

	beforeEach( ->
		dialog = new Confirm($)
	)

	afterEach( (done) ->
		if dialog.el
			dialog.el.remove()
			dialog.el = null

		Dialog.visible = null
		Dialog.closing = false

		if Overlay.visible
			Overlay.hide().then( -> done())
		else
			done()
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