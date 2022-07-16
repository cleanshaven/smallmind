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

{ #category : #adding }
BMTopic >> addIcon [ 
	| selection list |
	
	list := (ThemeIcons current icons associations reject: [ :each |
		self doNotDisplayIcons includes: each key asSymbol]) sorted: [:a :b | a < b ].
	
	selection := self application newSelect
		title: 'Choose Icon';
		label: 'Select an Icon';
    	items: list;
		display: [ :each | each key ];
		displayIcon: [ :each | each value ];
		openModal.
		
	selection ifNotNil: [ 
		self model addIcon: selection key asSymbol ]

]

{ #category : #adding }
BMTopic >> addImage [ 

	| fileName base64|
	fileName := UIManager default chooseFullFileNameMatching: #('*.png').
	fileName ifNotNil: [ 
		base64 := (Base64MimeConverter mimeEncode: fileName asFileReference binaryReadStream) contents.
		self model image: base64.
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

{ #category : #'as yet unclassified' }
BMTopic >> changeTask [ 
	self model nextTask.
	self model removeAllTaskIcons.
	self insertCurrentTaskIcon
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

{ #category : #'private ' }
BMTopic >> createIconList [
	
	^self model icons collect: [ :each || icon |
		icon := ThemeIcons current icons at: each.
		each->icon] thenReject: [ :each | self doNotDisplayIcons includes: each key asSymbol ]
]

{ #category : #menu }
BMTopic >> createMenu [

	self @ (RSMenuActivable new
		menuDo: [ :menu :box | 
			menu 
				add: BMMenuConstants addChild target: box selector: #addChild argument: #();
				add: BMMenuConstants addSibling target: box selector: #addSibling argument: #();
				add: BMMenuConstants edit target: box selector: #editText argument: #();
				add: BMMenuConstants details  target: box selector: #editDetails argument: #();
				add: BMMenuConstants link target: box selector: #editLink argument: #();
				add: BMMenuConstants color target: box selector: #editColor argument: #();
				add: BMMenuConstants font target: box selector: #editFont argument: #();
				addLine;
				add: BMMenuConstants addIcon target: box selector: #addIcon argument: #();
				add: BMMenuConstants removeIcon target: box selector: #removeIcon argument: #();
				addLine;
				add: BMMenuConstants copyNode target: box selector: #copy argument: #();
				add: BMMenuConstants cut target: box selector: #cut argument: #();
				add: BMMenuConstants paste target: box selector: #paste argument: #();
				addLine;
				add: BMMenuConstants addImage target: box selector: #addImage argument: #();
				add: BMMenuConstants removeImage target: box selector: #removeImage argument: #();
				addLine;
				add: BMMenuConstants changeTask target: box selector: #changeTask argument: #();
				addLine;
				add: BMMenuConstants delete target: box selector: #deleteNode argument: #()
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

{ #category : #'private ' }
BMTopic >> doNotDisplayIcons [
	^#(#bmNoteIcon #bmWebLinkIcon #bmCancelIcon #bmCompleteIcon #bmInProcessIcon #bmOnHoldIcon) asOrderedCollection
]

{ #category : #'menu messages' }
BMTopic >> editColor [ 
	| color |
	
	color := self getColor: self model foreColor.
	color ifNotNil: [ self model foreColor: color ]
]

{ #category : #actions }
BMTopic >> editDetails [
	| newText |
	newText := self getDetail: self model details.
	newText ifNotNil: [ 
		self model details: newText.
		newText isEmptyOrNil 
			ifTrue: [ self model removeIcon: #bmNoteIcon ] 
			ifFalse: [self model addIcon: #bmNoteIcon] ]

	
  

]

{ #category : #'menu messages' }
BMTopic >> editFont [

	| newFont |
	
	newFont := self getFont: self model font.
	newFont ifNotNil: [ self model font: newFont ]

]

{ #category : #'menu messages' }
BMTopic >> editLink [
	| newLink |
	newLink := self getLink: self model link.
	newLink ifNotNil: [ 
		self model link: newLink.
		self model link isEmptyOrNil 
			ifTrue: [ self model removeIcon: #bmWebLinkIcon ] 
			ifFalse: [self model addIcon: #bmWebLinkIcon]].
	

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
BMTopic >> getLink: initialText [
	
	
	^self application newRequest
		title: 'Link';
		label: 'Link';
		text: initialText;
		openModal. 
]

{ #category : #utilities }
BMTopic >> getText: initialText [
	
	
	^self application newRequest
		title: 'Node Text';
		label: 'Text';
		text: initialText;
		openModal. 
]

{ #category : #actions }
BMTopic >> gotoLink: aString [

	aString isEmptyOrNil ifFalse: [ WebBrowser openOn: aString ]
	
]

{ #category : #initialization }
BMTopic >> initialize [ 
	super initialize.
	self model: BMNode new.
"	self model when: BMAnnounceTextChanged do: [ :announcement | self labelChanged: announcement newData ].
	self model when: BMAnnounceFontChanged  do: [ :announcement | self fontChanged: announcement newData ].
	self model when: BMAnnounceForeColorChanged do: [ :announcement | self foreColorChanged: announcement newData ]."
	self model when: BMModelChanged do: [ :announcement | self modelChanged: announcement newData ].
	self color: Color transparent.
	self label: RSLabel new.
	self add: label.
	
	self extent: (self label textWidth@self label textHeight).
	self model foreColor: self defaultForeColor.
	self model font: self label font.

	self draggable.
	self createMenu.
	self when: RSMouseDoubleLeftClick do: [ :evt | self gotoLink: self model link ]

]

{ #category : #'as yet unclassified' }
BMTopic >> insertCurrentTaskIcon [
"^#(#new #inprogress #onhold #done #cancel) asOrderedCollection"

	| iconMap iconToInsert|
	iconMap := Dictionary with: #inprogress->#bmInProcessIcon
		with: #onhold->#bmOnHoldIcon
		with: #done->#bmCompleteIcon
		with: #cancel->#bmCancelIcon.
	iconToInsert := iconMap at: self model task current ifAbsent: [ nil ].
	iconToInsert ifNotNil: [ self model addIcon: iconToInsert ] 

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

	| totalExtent count startingPoint iconForm newIconShape myLabel tempY|
	
	self resetChildren.
	aModel font ifNotNil: [ self label font: aModel font ].
		aModel image isEmptyOrNil 
		ifFalse: [ | iconShape |
			iconForm :=  Form fromBase64String: aModel image.
			iconShape := RSBitmap new.
			iconShape
				form: iconForm;
				extent: 64@64.
			self add: iconShape.
			"iconShape translateTo: 0@self label extent y * 2."
			"self label pushFront"
		].

	myLabel := self label.
	myLabel
		color: aModel foreColor;
		model: aModel text;
		text: aModel text.
	totalExtent := aModel image isEmptyOrNil
		ifFalse: [ (8 * aModel icons size + self label extent x max: 64)
	        @ (self label extent y max: 64 ). ]
		ifTrue: [ (8 * aModel icons size + self label extent x)
	        @ (self label extent y ). ].
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
	tempY := aModel image isEmptyOrNil 
		ifTrue: [  0 ]
		ifFalse: [ totalExtent y / 2].
	aModel icons isEmpty
		ifTrue: [self label translateTo: 0@0]
		ifFalse: [ self label translateTo: (aModel icons size * 8) - (aModel icons size * 4) @ 0].
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

{ #category : #removing }
BMTopic >> removeIcon [
	| iconList selection |
	iconList := self createIconList.
	
	selection := self application newSelect
		title: 'Remove Icon';
		label: 'Select Icon to Remove';
		items: iconList;
		display: [ :each | each key ];
		displayIcon: [ :each | each value ];
		openModal.
		
	selection ifNotNil: [ 
		self model removeIcon: selection key asSymbol 
	]
		
]

{ #category : #removing }
BMTopic >> removeImage [ 
	self model image: ''
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
BMTopic >> writeIcon: icon to: writer [
	| attributes |
	
	attributes := Dictionary with: BMXMLTags iconAttribute->icon asString.
	writer tag: BMXMLTags icon attributes: attributes
]

{ #category : #writing }
BMTopic >> writeIcons: writer [

	self model icons do: [ :icon | self writeIcon: icon to: writer ]
]

{ #category : #writing }
BMTopic >> writeNode: writer [

	writer tag: self xmlNodeName with: [ 
		writer tag: BMXMLTags text with: self model text.
		self model details isEmptyOrNil ifFalse:[writer tag: 'detail' with: self model details].
		self model link isEmptyOrNil ifFalse: [ writer tag: 'link' with: self model link ].
		self model font bmWriteXMLTo: writer.
		self model foreColor bmWriteXMLTo: writer purpose: 'foreground'.
		self writeIcons: writer.
		self model image isEmptyOrNil ifFalse: [ 
			writer tag: 'image' with: [ writer cdata: self model image] ].
		self model task writeToXML: writer.
		self writeAdditionalTagsTo: writer. 
		self model children do: [ :node | node writeNode: writer ]]

]

{ #category : #writing }
BMTopic >> xmlNodeName [
	^BMXMLTags childNode
]
