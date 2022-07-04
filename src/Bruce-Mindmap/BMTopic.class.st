Class {
	#name : #BMTopic,
	#superclass : #RSComposite,
	#instVars : [
		'label',
		'detailIcon'
	],
	#category : #'Bruce-Mindmap-roassal'
}

{ #category : #'menu messages' }
BMTopic >> addChild [
	| text newNode line|
	
	text := self getText: ''.
	text ifNotNil: [ 
		newNode := BMTopic new.
		newNode model 
			text: text;
			font: nil;
			foreColor: Color black;
			parent: self.
		self model children add: newNode.
		self canvas add: newNode.
		line := RSBezier new.
		line 
			withBorderAttachPoint;
			from: self;
			to: newNode;
			controlPointsController: RSHorizontalCPAPController new.
		self canvas add: line.
		RSForceBasedLayout new charge: -1000; on: self canvas nodes.
		self canvas zoomToFit
	]
		
			
			

]

{ #category : #'menu messages' }
BMTopic >> addSibling [
	self model parent addChild

]

{ #category : #'private ' }
BMTopic >> adjustSize [ 
	self extent: self label textWidth@label textHeight.
	self updateCanvas

]

{ #category : #accessing }
BMTopic >> application [ 
	^self canvas application
]

{ #category : #clipboard }
BMTopic >> clipboard [ 
	^self application class clipboard
]

{ #category : #clipboard }
BMTopic >> clipboard: aString [
	^self application class clipboard: aString
]

{ #category : #removing }
BMTopic >> confirmDeleteChild [

	| ok |
	
	ok := SpConfirmDialog  new
		title: 'Confirm Delete Node';
		label: 'Are you sure (Child nodes will also be deleted';
		openModal.
	^ok

]

{ #category : #'menu messages' }
BMTopic >> copy [
	self toClipboard
]

{ #category : #initialization }
BMTopic >> createMenu [

	self @ (RSMenuActivable new
		menuDo: [ :menu :box | 
			menu 
				add: 'Add Child' target: box selector: #addChild argument: #();
				add: 'AddSibling' target: box selector: #addSibling argument: #();
				add: 'Edit' target: box selector: #editText argument: #();
				add: 'Details' target: box selector: #editDetails argument: #();
				add: 'Color' target: box selector: #editColor argument: #();
				add: 'Font' target: box selector: #editFont argument: #();
				addLine;
				add: 'Copy' target: box selector: #copy argument: #();
				add: 'Cut' target: box selector: #cut argument: #();
				add: 'Paste' target: box selector: #paste argument: #();
				addLine;
				add: 'Delete' target: box selector: #deleteNode argument: #()
				 ])
]

{ #category : #'menu messages' }
BMTopic >> cut [ 
	|canvas|
	canvas := self canvas.
	self toClipboard.
	self model parent deleteChild: self.
	canvas signalUpdate 
]

{ #category : #defaults }
BMTopic >> defaultForeColor [
	^Color black

]

{ #category : #removing }
BMTopic >> deleteAllChildren: node [
	
	node model children do: [ :child | self deleteAllChildren: child ].
	node remove

]

{ #category : #removing }
BMTopic >> deleteChild: child [

	self model children remove: child.
	self deleteAllChildren: child
]

{ #category : #removing }
BMTopic >> deleteNode [

	| canvas |
	canvas := self canvas.
	
	self confirmDeleteChild  ifTrue: [ 
		self model parent deleteChild: self.
		canvas signalUpdate ]

]

{ #category : #accessing }
BMTopic >> detailIcon [

	^ detailIcon
]

{ #category : #accessing }
BMTopic >> detailIcon: anObject [

	detailIcon := anObject
]

{ #category : #'menu messages' }
BMTopic >> editColor [ 
	| color |
	
	color := self getColor: self model foreColor.
	color ifNotNil: [ self model foreColor: color ]
]

{ #category : #actions }
BMTopic >> editDetails [
	| newText group detailsIcon iconShape|
	newText := self getDetail: self model details.
	newText ifNotNil: [ 
		self model details: newText.
		newText isEmptyOrNil 
			ifTrue: [ self model removeIcon: #detailIcon ] 
			ifFalse: [self model addIcon: #detailIcon. self model addIcon: #bitbucket] ]

	
  

]

{ #category : #'menu messages' }
BMTopic >> editFont [

	| newFont |
	
	newFont := self getFont: self model font.
	newFont ifNotNil: [ self model font: newFont ]

]

{ #category : #'menu messages' }
BMTopic >> editText [
	| newText |
	newText := self getText: self model text.
	newText ifNotNil: [ self model text: newText ]

]

{ #category : #'announcement handling' }
BMTopic >> fontChanged: aFont [
	self label font: aFont.
	self label text: self model text.
	self adjustSize.
	self updateCanvas
]

{ #category : #'announcement handling' }
BMTopic >> foreColorChanged: aColor [
	self label color: aColor.
	self updateCanvas

]

{ #category : #utilities }
BMTopic >> getColor: initialColor [
	| dialog |
	
	dialog := ColorSelectorDialogWindow new
		title: 'Choose color';
		selectedColor: initialColor.
	dialog openModal.
	^dialog cancelled
		ifTrue: [ nil ]
		ifFalse: [ dialog selectedColor ]

]

{ #category : #utilities }
BMTopic >> getDetail: initialText [
	
	
	^self application newRequestText
		title: self model text;
		label: 'Detail';
		text: initialText;
		openModal. 
]

{ #category : #utilities }
BMTopic >> getFont: initialFont [
	|newFont|
	newFont := nil.
	FontChooser 
		openModalWithTitle: 'Choose a Font'
		initialFont: initialFont 
		onAcceptDo: [ :e | newFont := e ].
	
	^newFont

]

{ #category : #utilities }
BMTopic >> getText: initialText [
	
	
	^self application newRequest
		title: 'Node Text';
		label: 'Text';
		text: initialText;
		openModal. 
]

{ #category : #initialization }
BMTopic >> initialize [ 
	super initialize.
	self model: BMNode new.
"	self model when: BMAnnounceTextChanged do: [ :announcement | self labelChanged: announcement newData ].
	self model when: BMAnnounceFontChanged  do: [ :announcement | self fontChanged: announcement newData ].
	self model when: BMAnnounceForeColorChanged do: [ :announcement | self foreColorChanged: announcement newData ]."
	self model when: BMModelChanged do: [ :announcement | self modelChanged: announcement newData ].
	self color: Color red.
	self label: RSLabel new.
	self add: label.
	self extent: (self label textWidth@self label textHeight).
	self model foreColor: self defaultForeColor.
	self model font: self label font.

	self draggable.
	self createMenu.

]

{ #category : #accessing }
BMTopic >> label [

	^ label
]

{ #category : #accessing }
BMTopic >> label: anObject [

	label := anObject
]

{ #category : #'announcement handling' }
BMTopic >> labelChanged: aString [
	self label text: aString.
	self adjustSize.
	self updateCanvas

]

{ #category : #'announcement handling' }
BMTopic >> modelChanged: aModel [

	| totalExtent count startingPoint iconForm newIconShape myLabel |
	self resetChildren.
	aModel font ifNotNil: [ self label font: aModel font ].
	myLabel := self label.
	myLabel
		color: aModel foreColor;
		model: aModel text;
		text: aModel text.
	totalExtent := 8 * aModel icons size + self label extent x
	        @ (self label extent y max: 8).
	self extent: totalExtent.
	startingPoint := ((self extent x / 2) * -1) + 4.
	count := 1.
	aModel icons do: [ :icon | 
		| iconShape |
		iconForm := self iconNamed: icon.
		iconShape := RSBitmap new.
		iconShape
			form: iconForm;
			extent: 8 @ 8.
		newIconShape := iconShape yourself.
		self add: newIconShape.
		newIconShape translateTo: startingPoint @ 0.
		startingPoint := startingPoint + 8 ].
	self add: self label.
	
	aModel icons size = 0 
		ifTrue: [self label translateTo: 0@0]
		ifFalse: [ self label translateTo: (aModel icons size * 8) - (aModel icons size * 4) @ 0 ].
		self label pushFront.

	self updateCanvas
]

{ #category : #'menu messages' }
BMTopic >> paste [

	| parser |
	
	parser := BMClipboardParser on: self clipboard. 
	parser 
		canvas: self canvas;
		parentNode: self;
		parseDocument
	
	
]

{ #category : #clipboard }
BMTopic >> toClipboard [
	| writer |
	
	writer := XMLWriter new.
	self 
		writeNode: writer;
		clipboard: writer asString

]

{ #category : #'private ' }
BMTopic >> updateCanvas [
	self canvas ifNotNil: [ self canvas signalUpdate ]
]

{ #category : #writing }
BMTopic >> writeAdditionalTagsTo: writer [

]

{ #category : #writing }
BMTopic >> writeNode: writer [

	writer tag: self xmlNodeName with: [ 
		writer tag: BMXMLTags text with: self model text.
		self model details isEmptyOrNil ifFalse:[writer tag: 'detail' with: self model details].
		self model font bmWriteXMLTo: writer.
		self model foreColor bmWriteXMLTo: writer purpose: 'foreground'.
		self writeAdditionalTagsTo: writer. 
		self model children do: [ :node | node writeNode: writer ]]

]

{ #category : #writing }
BMTopic >> xmlNodeName [
	^BMXMLTags childNode
]
