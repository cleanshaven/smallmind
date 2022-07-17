Class {
	#name : #BMMainTopic,
	#superclass : #BMTopic,
	#instVars : [
		'circle',
		'filename'
	],
	#category : #'Bruce-Mindmap-roassal'
}

{ #category : #'private ' }
BMMainTopic >> adjustSize [
	self circle ifNotNil: [self circle size: (self label textWidth) + 5].
	self size: (self label textWidth) + 5.
	self updateCanvas 
]

{ #category : #'announcement handling' }
BMMainTopic >> backgroundColorChanged: aColor [
	self circle color: aColor.
	self updateCanvas

]

{ #category : #accessing }
BMMainTopic >> circle [

	^ circle
]

{ #category : #accessing }
BMMainTopic >> circle: anObject [

	circle := anObject
]

{ #category : #menu }
BMMainTopic >> createFileMenu: box [
	^MenuMorph new
		add: BMMenuConstants open target: box selector: #openMap argument: #();
		add: BMMenuConstants save target: box selector: #saveMap argument: #();
		add: 'Save As...' target: box selector: #saveAsMap argument: #();
		yourself
		
]

{ #category : #menu }
BMMainTopic >> createMenu [
	self @ (RSMenuActivable new
		menuDo: [ :menu :box | 
			menu 
				add: BMMenuConstants addChild target: box selector: #addChild argument: #();
				add: BMMenuConstants edit target: box selector: #editText argument: #();
				add: BMMenuConstants details target: box selector: #editDetails argument: #();
				add: BMMenuConstants link target: box selector: #editLink argument: #();

				add: BMMenuConstants color target: box selector: #editColor argument: #();

				add: BMMenuConstants backgroundColor target: box selector: #editBackgroundColor argument: #();
				add: BMMenuConstants font target: box selector: #editFont argument: #();
				addLine;
				add: BMMenuConstants addIcon target: box selector: #addIcon argument: #();
				add: BMMenuConstants removeIcon target: box selector: #removeIcon argument: #();
				addLine;
				add: BMMenuConstants paste target: box selector: #paste argument: #();
				addLine;
				add: BMMenuConstants addImage target: box selector: #addImage argument: #();
				add: BMMenuConstants removeImage target: box selector: #removeImage argument: #();
				addLine;
				add: BMMenuConstants changeTask target: box selector: #changeTask argument: #();
				add: 'Task' subMenu: (self taskMenu: box);

				addLine;

				add: 'File' subMenu: (self createFileMenu: box)])
]

{ #category : #defaults }
BMMainTopic >> defaultBackgroundColor [ 
	^Color gray

]

{ #category : #actions }
BMMainTopic >> editBackgroundColor [
	
	"comment stating purpose of instance-side method"
	"scope: class-variables  &  instance-variables"	
			
	| color |
	
	color := self getColor: self model backgroundColor.
	color ifNotNil: [ self model backgroundColor: color ]
]

{ #category : #accessing }
BMMainTopic >> filename [

	^ filename
]

{ #category : #accessing }
BMMainTopic >> filename: anObject [

	filename := anObject
]

{ #category : #initialization }
BMMainTopic >> initialize [
	super initialize.

	self circle: RSCircle new.
	self add: self circle.
	self model text: 'My Mind'.
	self model backgroundColor: self defaultBackgroundColor.
	self model when: BMAnnounceBackgroundColorChanged do: [ :annoucement |  self backgroundColorChanged: annoucement newData].
	self filename: nil
	"self label pushFront."

]

{ #category : #'announcement handling' }
BMMainTopic >> modelChanged: aModel [
	| aCircle |
	super modelChanged: aModel.
	aCircle := RSCircle new.
	aCircle extent: (self model image isEmptyOrNil 
							ifTrue: [(self extent x + 5)@(self extent x + 5)]
							ifFalse: [ ((self extent x + 5)max:64 + 5)@((self extent x + 5 )max:64 + 5) ] ).
	self add: aCircle.
	self extent: aCircle extent.
	aCircle pushBack.
	self signalUpdate
	
		

]

{ #category : #actions }
BMMainTopic >> openMap [

	| fileName parser stream  canvas|
	
	fileName := UIManager default chooseFullFileNameMatching: #('*.xml').
	fileName ifNotNil: [
		canvas := self canvas.
		self canvas clear.
		stream := fileName asFileReference readStream. 
		parser := BMSAXParser on: stream.
		parser canvas: canvas.
		parser parseDocument.
		stream close.
		canvas filename: fileName
	]
]

{ #category : #writing }
BMMainTopic >> saveAsMap [

	| reference writer canvas|
	
	canvas := self canvas.
	reference := UIManager default 
			chooseForSaveFileReference: 'Save Mindmap as?'
			extensions: #()
			path: ''.
	
	reference ifNotNil: [ 
		writer := XMLWriter new.
	"	writer enablePrettyPrinting."
		writer 
			tag: BMXMLTags mindmap with: [ self writeNode: writer ].
		reference writeStreamDo: [ :stream | 
			stream 
				truncate;
				<< writer asString
		].
		canvas filename: reference fullName.
		self inform: 'Mindmap Saved'
	]
]

{ #category : #writing }
BMMainTopic >> saveMap [

	| reference writer canvas|
	
	canvas := self canvas.
	self canvas filename isEmptyOrNil 
		ifTrue: [  
			reference := UIManager default 
			chooseForSaveFileReference: 'Save Mindmap as?'
			extensions: #()
			path: '']
		ifFalse: [ reference := self canvas filename asFileReference ].
	
	reference ifNotNil: [ 
		writer := XMLWriter new.
	"	writer enablePrettyPrinting."
		writer 
			tag: BMXMLTags mindmap with: [ self writeNode: writer ].
		reference writeStreamDo: [ :stream | 
			stream 
				truncate;
				<< writer asString
		].
		canvas filename: reference fullName.
		self inform: 'Mindmap Saved'
	]
]

{ #category : #writing }
BMMainTopic >> writeAdditionalTagsTo: writer [
	super writeAdditionalTagsTo: writer.
	self model backgroundColor bmWriteXMLTo: writer purpose: 'background'

]

{ #category : #writing }
BMMainTopic >> xmlNodeName [ 
	^BMXMLTags rootNode

]
