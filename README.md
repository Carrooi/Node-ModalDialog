# Modal dialog

Window modal dialogs for browser (eg. with [simq](https://npmjs.org/package/simq)).
Depends on jQuery, instance of EventEmitter, uses [q](https://npmjs.org/package/q) promise library.

## Abandoned

Unfortunately I don't have any more time to maintain this repository :-(

![sad cat](https://raw.githubusercontent.com/sakren/sakren.github.io/master/images/sad-kitten.jpg)

## Installation

```
$ npm install modal-dialog
```

## Usage

```
var Dialog = require('modal-dialog');

var d = new Dialog(window.jQuery);
d.title = 'Title of my window';
d.content = 'Lorem lipsum dolor sit amet...';
d.info = 'Info in footer';
d.addButton('OK', function() {
	alert('OK button was clicked');
	d.hide();
});
d.show();
```

If you want to set some element directly into header or footer, you can set these variables. `Title` and `info` variables
are just shortcuts for setting texts.

```
d.header = $('<div>my custom header</div>');
d.footer = $('<div>my custom footer</div>');
```

## Changing data of created dialog

There are three methods for changing data. Unfortunately you can not change everything (just title, content and info).

```
d.changeTitle('new title');
d.changeContent('new content');
d.changeInfo('new info');
```

## Styling

This modal dialog comes with one simple style which is sincerely horrible, so I recommend to use your own style. You just
have to disable the default one.

```
Dialog.styles = false;
```

Now you can write your own styles in your css files. Modal dialog has got some classes for you. Names of these classes can
be also changed in variable `classes`. Here are the default ones.

```
Dialog.classes = {
	container: 'modal_dialog',
	title: 'title',
	header: 'header',
	content: 'content',
	footer: 'footer',
	info: 'info',
	buttons: 'buttons',
	button: 'button',
};
```

## Options

Settings described above were default settings, but you can set these options for each dialog separately.

```
d.show({
	styles: false
});
```

### List of options

* width
* maxHeight
* duration (speed of animation in jquery)
* zIndex
* styles (disable or allow default styles)
* classes (override default classes names)
* overlay (list of options for [overlay](https://npmjs.org/package/overlay) package)

## Confirmation dialog

There is prepared also simple confirmation dialog with two buttons (`OK` and `Cancel`).

```
var Confirm = require('modal-dialog/ConfirmDialog');

var c = new Confirm(window.jQuery, 'Are you really want to continue?');
c.on('true', function() {
	alert('You clicked on the OK button');
});
c.on('false', function() {
	alert('You clicked on the Cancel button');
});
```

Here is how to set own captions for these two buttons.

```
var c = new Confirm(window.jQuery, 'Some question', 'Yes', 'No');
```

## Events

* `beforeShow` (dialog): Called before dialog is opened
* `afterShow` (dialog): Called after dialog is opened (after all animations)
* `beforeHide` (dialog): Called before dialog is closed
* `afterHide` (dialog): Called after dialog is closed (after all animations)
* `true` (only confirmations): Called when true button is clicked
* `false` (only confirmations): Called when false button is clicked

Example:
```
d.on('afterShow', function(dialog) {
	d === dialog; //true

	console.log('Window is open');
});
```

## Tests

```
$ npm test
```

## Changelog

* 1.6.3
	+ Moved to Carrooi organization
	+ Abandon package

* 1.6.2
	+ Little optimization

* 1.6.1
	+ Bug with changing elements

* 1.6.0
	+ Optimizations
	+ Added changeTitle, changeContent and changeInfo methods
	+ Optimized tests

* 1.5.0
	+ onTrue and onFalse in confirmations replaced with eventEmitter events
	+ overlay did not hide in some situations

* 1.4.0
	+ jQuery must be passed in constructor

* 1.3.3 - 1.3.4
	+ Some optimizations
	+ Updated tests

* 1.3.2
	+ Uses [content-ready](https://npmjs.org/package/content-ready) module
	+ Added many other tests

* 1.3.1
	+ Added tests

* 1.3.0
	+ Instance of EventEmitter
	+ Added some events

* 1.2.2 - 1.2.4
	+ Showing dialog in right position after all images all loaded

* 1.2.1
	+ Bug with custom styles

* 1.2.0
	+ Added `isOpen` method

* 1.1.1
	+ Some bugs

* 1.1.0
	+ Added confirm dialog

* 1.0.0
	+ Initial version

