# Modal dialog

Window modal dialogs for browser

## Changelog

Changelog is in the bottom of this readme.

## Usage

```
var Dialog = require('modal-dialog');

var d = new Dialog;
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

var c = new Confirm('Are you really want to continue?');
c.onTrue(function() {
	alert('You clicked on the OK button');
});
c.onFalse(function() {
	alert('You clicked on the Cancel button');
});
```

Here is how to set own captions for these two buttons.

```
var c = new Confirm('Some question', 'Yes', 'No');
```

## Changelog

* 1.2.2
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