Dialog = require 'Dialog'
Overlay = require 'overlay'
Q = require 'q'

Q.stopUnhandledRejectionTracking()

dialog = null


describe 'Dialog', ->

	beforeEach( ->
		dialog = new Dialog
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

	describe '#show()', ->
		it 'should show and create dialog element', (done) ->
			dialog.show().then( ->
				expect(dialog.el).not.to.be.null
				expect(dialog.el.is(':visible')).to.be.true
				expect(Dialog.visible).to.be.equal(dialog)
				done()
			).done()

		it 'should return an error if dialog is already open', (done) ->
			dialog.show().then( ->
				dialog.show().fail( (err) ->
					expect(err).to.be.instanceof(Error)
					expect(err.message).to.be.equal('This modal dialog is already open.')
					done()
				)
			)

		it 'should return an error if another dialog is open', (done) ->
			d = new Dialog
			d.show().then( ->
				dialog.show().fail( (err) ->
					expect(err).to.be.instanceof(Error)
					expect(err.message).to.be.equal('Another modal dialog is open.')
					d.hide().then( ->
						done()
					).done()
				).done()
			).done()

		it 'element of new dialog should be empty', (done) ->
			dialog.show().then( ->
				expect(dialog.el.html()).to.be.equal('')
				done()
			).done()

		it 'should set title of dialog', (done) ->
			dialog.title = 'some title'
			dialog.show().then( ->
				title = $(dialog.el).find('div.header span.title')
				expect(title.length).to.be.equal(1)
				expect(title.html()).to.be.equal('some title')
				done()
			).done()

		it 'should set html header', (done) ->
			dialog.header = $('<span class="my-header">header</span>')
			dialog.show().then( ->
				header = $(dialog.el).find('div.header')
				expect(header.length).to.be.equal(1)
				expect(header.html()).to.be.equal('<span class="my-header">header</span>')
				done()
			).done()

		it 'should set some content', (done) ->
			dialog.content = 'my content'
			dialog.show().then( ->
				content = $(dialog.el).find('div.content')
				expect(content.length).to.be.equal(1)
				expect(content.html()).to.be.equal('my content')
				done()
			).done()

		it 'should add some buttons', (done) ->
			dialog.addButton 'ok'
			dialog.show().then( ->
				buttons = $(dialog.el).find('div.buttons a')
				expect(buttons.length).to.be.equal(1)
				expect(buttons.html()).to.be.equal('ok')
				done()
			).done()

		it 'should set simple information text', (done) ->
			dialog.info = 'info text'
			dialog.show().then( ->
				info = $(dialog.el).find('div.footer span.info')
				expect(info.length).to.be.equal(1)
				expect(info.html()).to.be.equal('info text')
				done()
			).done()

		it 'should set html footer', (done) ->
			dialog.footer = $('<div class="my-footer">footer</div>')
			dialog.show().then( ->
				footer = $(dialog.el).find('div.footer')
				expect(footer.length).to.be.equal(1)
				expect(footer.html()).to.be.equal('<div class="my-footer">footer</div>')
				done()
			).done()

	describe '#addButton()', ->
		it 'should add three buttons', ->
			dialog.addButton 'ok'
			dialog.addButton 'cancel'
			expect(dialog.buttons.length).to.be.equal(2)

		it 'should call button action after it is clicked', (done) ->
			dialog.addButton 'ok', -> done()
			dialog.show().then( ->
				button = $(dialog.el).find('div.buttons a')
				button.click()
			).done()

		it 'should call right button action when it is clicked', (done) ->
			dialog.addButton 'cancel'
			dialog.addButton 'ok', -> done()
			dialog.addButton 'close'
			dialog.show().then( ->
				button = $(dialog.el).find('div.buttons a:nth-child(2)')
				button.click()
			)

	describe '#isOpen()', ->
		it 'should return false when dialog is closed', ->
			expect(dialog.isOpen()).to.be.false

		it 'should return true when dialog is open', (done) ->
			dialog.show().then( ->
				expect(dialog.isOpen()).to.be.true
				done()
			).done()

		it 'should return false after dialog is again closed', (done) ->
			dialog.show().then( ->
				dialog.hide().then( ->
					expect(dialog.isOpen()).to.be.false
					done()
				).done()
			).done()

	describe '#hide()', ->
		it 'should hide created dialog', (done) ->
			dialog.show().then( ->
				dialog.hide().then( ->
					expect(dialog.el.is(':hidden')).to.be.true
					expect(Dialog.visible).to.be.null
					done()
				).done()
			).done()

		it 'should return an error if dialog is not open', (done) ->
			dialog.hide().fail( (err) ->
				expect(err).to.be.instanceof(Error)
				expect(err.message).to.be.equal('This window is not open.')
				done()
			).done()