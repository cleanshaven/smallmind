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

{ #category : #'as yet unclassified' }
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
				add: 'Add Child' target: box selector: #addChild argument: #();
				add: 'Edit' target: box selector: #editText argument: #();
				add: 'Color' target: box selector: #editColor argument: #();
				add: 'Background Color' target: box selector: #editBackgroundColor argument: #();
				add: 'Font' target: box selector: #editFont argument: #()
				 ])
]

{ #category : #defaults }
BMMainTopic >> defaultBackgroundColor [ 
	^Color gray

]

{ #category : #'as yet unclassified' }
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
	self label pushFront.

]
