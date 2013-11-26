Q = require 'q'
Overlay = require 'overlay'
ready = require 'content-ready'
EventEmitter = require('events').EventEmitter

$ = null

class Dialog extends EventEmitter


	@visible: null

	@closing: false

	@overlayRegistered: false

	@classes:
		container: 'modal_dialog'
		title: 'title'
		header: 'header'
		content: 'content'
		footer: 'footer'
		info: 'info'
		buttons: 'buttons'
		button: 'button'

	@styles: true


	options: null

	title: null

	header: null

	content: null

	footer: null

	info: null

	buttons: null

	width: 430

	maxHeight: 400

	zIndex: 100000

	duration: 'fast'

	el: null

	elements: null


	constructor: (jquery = null) ->
		if jquery == null
			try jquery = require 'jquery' catch err then jquery = window.jQuery		# deprecated

		if !jquery
			throw new Error 'jquery is not defined.'

		$ = jquery

		@buttons = []
		@elements = {}

		if Dialog.overlayRegistered == false
			Dialog.overlayRegistered = true
			Overlay.on('hide', =>
				if Dialog.visible != null && Dialog.closing == false
					Dialog.visible.hide()
			)


	addButton: (title, action) ->
		@buttons.push(
			title: title
			action: action
		)
		return @


	parseOptions: (options = {}) ->
		if typeof options.width == 'undefined' then options.width = @width
		if typeof options.maxHeight == 'undefined' then options.maxHeight = @maxHeight
		if typeof options.duration == 'undefined' then options.duration = @duration
		if typeof options.zIndex == 'undefined' then options.zIndex = @zIndex
		if typeof options.styles == 'undefined' then options.styles = Dialog.styles
		if typeof options.classes == 'undefined' then options.classes = {}
		if typeof options.overlay == 'undefined' then options.overlay = {}
		if typeof options.classes.container == 'undefined' then options.classes.container = Dialog.classes.container
		if typeof options.classes.title == 'undefined' then options.classes.title = Dialog.classes.title
		if typeof options.classes.header == 'undefined' then options.classes.header = Dialog.classes.header
		if typeof options.classes.content == 'undefined' then options.classes.content = Dialog.classes.content
		if typeof options.classes.footer == 'undefined' then options.classes.footer = Dialog.classes.footer
		if typeof options.classes.info == 'undefined' then options.classes.info = Dialog.classes.info
		if typeof options.classes.buttons == 'undefined' then options.classes.buttons = Dialog.classes.buttons
		if typeof options.classes.button == 'undefined' then options.classes.button = Dialog.classes.button

		options.overlay.duration = options.duration

		return options


	renderHeader: ->
		if typeof @elements.header == 'undefined'
			@elements.header = $('<div>',
				'class': @options.classes.header
			)

		@elements.header.html('')

		if @header || @title
			if @header
				@elements.header.html(@header)
			else
				@elements.header.html('<span class="' + @options.classes.title + '">' + @title + '</span>')

		return @elements.header


	renderContent: ->
		if typeof @elements.content == 'undefined'
			@elements.content = $('<div>',
				'class': @options.classes.content
			)

		@elements.content.html('')

		if @content != null
			@elements.content.html(@content)

		return @elements.content


	renderFooter: ->
		if typeof @elements.footer == 'undefined'
			@elements.footer = $('<div>',
				'class': @options.classes.footer,
			)

		@elements.footer.html('')

		delete @elements.info if typeof @elements.info != 'undefined'
		delete @elements.buttons if typeof @elements.buttons != 'undefined'

		if @footer || @info || @buttons.length > 0
			if @footer
				@elements.footer.html(@footer)
			else
				if @info
					@elements.info = $('<span class="' + @options.classes.info + '">' + @info + '</span>').appendTo(@elements.footer)

				if @buttons.length > 0
					@elements.buttons = $('<div class="' + @options.classes.buttons + '">')

					for button in @buttons
						( (button) =>
							$('<a>',
								html: button.title
								href: '#'
								'class': @options.classes.button
								click: (e) =>
									e.preventDefault()
									button.action.call(@)
							).appendTo(@elements.buttons)
						)(button)
					@elements.buttons.appendTo(@elements.footer)

		return @elements.footer


	refreshStyles: (type = null) ->
		if type == null || type == 'header'
			if @elements.header.html() == ''
				@elements.header.removeAttr('styles')
			else if @options.styles
				@elements.header.css(
					borderBottom: '1px solid black'
					paddingBottom: '8px'
				)

		if type == null || type == 'content'
			styles =
				maxHeight: @options.maxHeight
				overflow: 'hidden'
				overflowX: 'auto'
				overflowY: 'auto'
			if @elements.content.html() == ''
				@elements.content.removeAttr('styles')
			else if @options.styles
				styles.borderBottom = '1px solid black'
				styles.paddingTop = '8px'
				styles.paddingBottom = '8px'
			@elements.content.css(styles)

		if type == null || type == 'footer'
			if @elements.footer.html() == ''
				@elements.footer.removeAttr('styles')
			else if @options.styles
				@elements.footer.css(paddingTop: '8px')
				if !@footer && @buttons.length > 0
					@elements.buttons.css('float': 'right')


	render: ->
		if @options == null
			@options = @parseOptions()

		@el = $('<div>',
			'class': @options.classes.container
			css:
				display: 'none'
				position: 'fixed'
				left: '50%'
				top: '50%'
		).appendTo($('body'))

		styles =
			zIndex: @options.zIndex
			width: @options.width
			marginLeft: -(@options.width / 2)
			marginTop: -(@options.maxHeight / 2)
		if @options.styles
			styles.border = '1px solid black'
			styles.backgroundColor = 'white'
			styles.padding = '10px 12px 10px 12px'
		@el.css(styles)

		@el.append(@renderHeader())
		@el.append(@renderContent())
		@el.append(@renderFooter())

		@refreshStyles()


	moveToCenter: ->
		deferred = Q.defer()

		@el.css(
			display: 'block'
			visibility: 'hidden'
		)
		ready(@el).then( =>
			height = parseInt(@el.css('height'))
			@el.css(
				visibility: 'visible'
				marginTop: -(height / 2)
			)

			deferred.resolve(@)
		)

		return deferred.promise


	show: (options = {}) ->
		if Dialog.visible == null
			@emit 'beforeShow', @

			@options = @parseOptions(options)

			if @el == null
				@render()

			deferred = Q.defer()

			@moveToCenter().then( =>
				finish = =>
					@emit 'afterShow', @
					deferred.resolve(@)

				done =
					overlay: false
					dialog: false

				Overlay.show(@options.overlay).then( =>
					done.overlay = true
					if done.dialog then finish(deferred)
				)
				@el.fadeIn(@options.duration, (e) =>
					Dialog.visible = @
					done.dialog = true
					if done.overlay then finish(deferred)
				)
			)

			return deferred.promise
		else if Dialog.visible == @
			return Q.reject(new Error('This modal dialog is already open.'))
		else
			return Q.reject(new Error('Another modal dialog is open.'))


	hide: ->
		deferred = Q.defer()

		if !@isOpen()
			deferred.reject(new Error('This window is not open.'))
		else
			@emit 'beforeHide'

			Dialog.closing = true
			Overlay.hide()
			@el.fadeOut( =>
				Dialog.visible = null
				Dialog.closing = false

				@emit 'afterHide', @
				deferred.resolve(@)
			)

		return deferred.promise


	changeTitle: (@title) ->
		@header = null

		@renderHeader()
		@refreshStyles('header')

		return @


	changeContent: (@content) ->
		if @content == null
			@elements.content.html('')

		@renderContent()
		@refreshStyles('content')

		return @


	changeInfo: (@info) ->
		if @info == null && typeof @elements.info != 'undefined'
			@elements.info.remove()
			delete @elements.info

		@renderFooter()
		@refreshStyles('footer')

		return @


	isOpen: ->
		return Dialog.visible == @


module.exports = Dialog