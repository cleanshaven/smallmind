Class {
	#name : #BMTopic,
	#superclass : #RSComposite,
	#instVars : [
		'label'
	],
	#category : #'Bruce-Mindmap-roassal'
}

{ #category : #adding }
BMTopic >> addChild [
	| text newNode line|
	
	text := self getText: ''.
	text ifNotNil: [ 
		newNode := BMTopic new.
		newNode model 
			text: text;
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

{ #category : #adding }
BMTopic >> addSibling [
	self model parent addChild

]

{ #category : #'private ' }
BMTopic >> adjustSize [ 
	self extent: self label textWidth@label textHeight.
	self updateCanvas

]

{ #category : #initialization }
BMTopic >> createMenu [

	self @ (RSMenuActivable new
		menuDo: [ :menu :box | 
			menu 
				add: 'Add Child' target: box selector: #addChild argument: #();
				add: 'AddSibling' target: box selector: #addSibling argument: #();
				add: 'Edit' target: box selector: #editText argument: #();
				add: 'Color' target: box selector: #editColor argument: #();
				add: 'Font' target: box selector: #editFont argument: #();
				addLine;
				add: 'Delete' target: box selector: #deleteNode argument: #()
				 ])
]

{ #category : #'as yet unclassified' }
BMTopic >> defaultForeColor [
	^Color black

]

{ #category : #'trait rendering' }
BMTopic >> editColor [ 
	| color |
	
	color := self getColor: self model foreColor.
	color ifNotNil: [ self model foreColor: color ]
]

{ #category : #'as yet unclassified' }
BMTopic >> editFont [

	| newFont |
	
	newFont := self getFont: self model font.
	newFont ifNotNil: [ self model font: newFont ]

]

{ #category : #actions }
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
	^SpRequestDialog new
		title: 'Node Text';
		label: 'Text';
		text: initialText;
		openModal. 
]

{ #category : #initialization }
BMTopic >> initialize [ 
	super initialize.
	self model: BMNode new.
	self model when: BMAnnounceTextChanged do: [ :announcement | self labelChanged: announcement newData ].
	self model when: BMAnnounceFontChanged  do: [ :announcement | self fontChanged: announcement newData ].
	self model when: BMAnnounceForeColorChanged do: [ :announcement | self foreColorChanged: announcement newData ].
	self color: Color transparent.
	self label: RSLabel new.
	self add: label.
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

{ #category : #'private ' }
BMTopic >> updateCanvas [
	self canvas ifNotNil: [ self canvas signalUpdate ]
]
