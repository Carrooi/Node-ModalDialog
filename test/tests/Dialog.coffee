Dialog = require 'Dialog'
Overlay = require 'overlay'
Q = require 'q'

Q.stopUnhandledRejectionTracking()

$ = window.jQuery
dialog = null


describe 'Dialog', ->

	beforeEach( ->
		dialog = new Dialog($)
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

		it 'element of new dialog should be empty', ->
			dialog.render()
			expect(dialog.el.find('div').length).to.be.equal(3)
			expect(dialog.el.find('div.header').html()).to.be.equal('')
			expect(dialog.el.find('div.content').html()).to.be.equal('')
			expect(dialog.el.find('div.footer').html()).to.be.equal('')

		it 'should set title of dialog', ->
			dialog.title = 'some title'
			dialog.render()
			title = dialog.elements.header.children('span')
			expect(title.length).to.be.equal(1)
			expect(title.html()).to.be.equal('some title')

		it 'should set html header', ->
			dialog.header = $('<span class="my-header">header</span>')
			dialog.render()
			expect(dialog.elements.header.html()).to.be.equal('<span class="my-header">header</span>')

		it 'should set some content', ->
			dialog.content = 'my content'
			dialog.render()
			expect(dialog.elements.content.html()).to.be.equal('my content')

		it 'should add some buttons', ->
			dialog.addButton 'ok'
			dialog.render()
			expect(dialog.elements.footer.find('div.buttons a').html()).to.be.equal('ok')

		it 'should set simple information text', ->
			dialog.info = 'info text'
			dialog.render()
			expect(dialog.elements).to.contain.keys(['info'])
			expect(dialog.elements.info.html()).to.be.equal('info text')

		it 'should set html footer', ->
			dialog.footer = $('<div class="my-footer">footer</div>')
			dialog.render()
			expect(dialog.elements.footer.html()).to.be.equal('<div class="my-footer">footer</div>')

	describe '#addButton()', ->

		it 'should add three buttons', ->
			dialog.addButton 'ok'
			dialog.addButton 'cancel'
			expect(dialog.buttons.length).to.be.equal(2)

		it 'should call button action after it is clicked', (done) ->
			dialog.addButton 'ok', -> done()
			dialog.render()
			dialog.elements.footer.find('div.buttons a').click()

		it 'should call right button action when it is clicked', (done) ->
			dialog.addButton 'cancel'
			dialog.addButton 'ok', -> done()
			dialog.addButton 'close'
			dialog.render()
			dialog.elements.footer.find('div.buttons a:nth-child(2)').click()

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

	describe '#changeTitle()', ->

		it 'should change title of dialog', ->
			dialog.title = 'first'
			dialog.render()
			expect(dialog.elements.header.children('span').html()).to.be.equal('first')
			dialog.changeTitle('second')
			expect(dialog.elements.header.children('span').html()).to.be.equal('second')

	describe '#changeContent()', ->

		it 'should change content of dialog', ->
			dialog.content = 'first'
			dialog.render()
			expect(dialog.elements.content.html()).to.be.equal('first')
			dialog.changeContent('second')
			expect(dialog.elements.content.html()).to.be.equal('second')

		it 'should clear content of dialog', ->
			dialog.content = 'text'
			dialog.render()
			dialog.changeContent(null)
			expect(dialog.elements.content.html()).to.be.equal('')

	describe '#changeInfo()', ->

		it 'should change info of dialog', ->
			dialog.info = 'first'
			dialog.render()
			expect(dialog.elements.info.html()).to.be.equal('first')
			dialog.changeInfo('second')
			expect(dialog.elements.info.html()).to.be.equal('second')

		it 'should remove old info from dialog', ->
			dialog.info = 'first'
			dialog.render()
			dialog.changeInfo(null)
			expect(dialog.elements.footer.html()).to.be.equal('')
			expect(dialog.elements).not.to.contain.keys(['info'])