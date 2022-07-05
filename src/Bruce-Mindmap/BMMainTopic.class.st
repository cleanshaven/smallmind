Class {
	#name : #BMMainTopic,
	#superclass : #BMTopic,
	#instVars : [
		'circle'
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

{ #category : #initialization }
BMMainTopic >> createMenu [
	self @ (RSMenuActivable new
		menuDo: [ :menu :box | 
			menu 
				add: BMMenuConstants addChild target: box selector: #addChild argument: #();
				add: BMMenuConstants edit target: box selector: #editText argument: #();
				add: BMMenuConstants details target: box selector: #editDetails argument: #();

				add: BMMenuConstants color target: box selector: #editColor argument: #();

				add: BMMenuConstants backgroundColor target: box selector: #editBackgroundColor argument: #();
				add: BMMenuConstants font target: box selector: #editFont argument: #();
				addLine;
				add: BMMenuConstants addIcon target: box selector: #addIcon argument: #();
				add: BMMenuConstants removeIcon target: box selector: #removeIcon argument: #();
				addLine;
				add: BMMenuConstants paste target: box selector: #paste argument: #();
				addLine;
				add: BMMenuConstants save target: box selector: #saveMap argument: #();
				add: BMMenuConstants open target: box selector: #openMap argument: #()
		])
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

{ #category : #initialization }
BMMainTopic >> initialize [
	super initialize.

	self circle: RSCircle new.
	self add: self circle.
	self model text: 'My Mind'.
	self model backgroundColor: self defaultBackgroundColor.
	self model when: BMAnnounceBackgroundColorChanged do: [ :annoucement |  self backgroundColorChanged: annoucement newData].
	"self label pushFront."

]

{ #category : #'announcement handling' }
BMMainTopic >> modelChanged: aModel [
	| aCircle |
	super modelChanged: aModel.
	
	self extent: (self extent x + 5)@(self extent x + 5).
	aCircle := (RSCircle new extent: self extent; yourself).
	self add: aCircle.
	aCircle pushBack
	
		

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
		stream close
	]
]

{ #category : #writing }
BMMainTopic >> saveMap [

	| reference writer|
	
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
				<< writer asString;
				close ]
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
