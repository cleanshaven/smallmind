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

{ #category : #accessing }
BMTopic >> application [ 
	^self canvas application
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
				add: 'Delete' target: box selector: #deleteNode argument: #()
				 ])
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

	self confirmDeleteChild  ifTrue: [ 
		self model parent deleteChild: self.
		self updateCanvas ]

]

{ #category : #'trait rendering' }
BMTopic >> editColor [ 
	| color |
	
	color := self getColor: self model foreColor.
	color ifNotNil: [ self model foreColor: color ]
]

{ #category : #actions }
BMTopic >> editDetail [
	| newText |
	newText := self getDetail: self model detail.
	newText ifNotNil: [ self model details: newText ]

]

{ #category : #actions }
BMTopic >> editDetails [
	| newText |
	newText := self getDetail: self model details.
	newText ifNotNil: [ self model details: newText ]

]

{ #category : #actions }
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
