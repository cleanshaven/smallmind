Class {
	#name : #BMSAXParser,
	#superclass : #SAXHandler,
	#instVars : [
		'stack',
		'stringBuilder',
		'canvas'
	],
	#category : #'Bruce-Mindmap-SAX'
}

{ #category : #accessing }
BMSAXParser >> canvas [

	^ canvas
]

{ #category : #accessing }
BMSAXParser >> canvas: anObject [

	canvas := anObject
]

{ #category : #'handling - content' }
BMSAXParser >> characters: aString [
	self stringBuilder: self stringBuilder, aString

]

{ #category : #'handling - content' }
BMSAXParser >> endDocument [ 

	| lineBuilder |
	
	lineBuilder := RSLineBuilder bezier.
	lineBuilder canvas: self canvas.
	lineBuilder withBorderAttachPoint.
	lineBuilder connectFrom: #parentModel.	

]

{ #category : #'handling - content' }
BMSAXParser >> endElement: aQualifiedName [

	aQualifiedName = 'text' ifTrue: [ self handleEndText ].
	aQualifiedName = 'node' ifTrue: [ self handleEndNode ].
	aQualifiedName = BMXMLTags rootNode ifTrue: [ self handleEndRoot ].
]

{ #category : #'handling - content' }
BMSAXParser >> handleChildNode [

	| childNode |
	
	childNode := BMTopic new.
	self push: childNode

]

{ #category : #'handling - content' }
BMSAXParser >> handleColor: anAttributeDictionary [
	| color |
	
	color := Color 
		r: (anAttributeDictionary at: 'red') asFloatPoint
		g: (anAttributeDictionary at: 'green') asFloatPoint 
		b: (anAttributeDictionary at: 'blue') asFloatPoint 
		alpha: (anAttributeDictionary at: 'alpha') asFloatPoint.
		
	(anAttributeDictionary at: 'purpose') = 'foreground' ifTrue: [ self top model foreColor: color ].
	(anAttributeDictionary at: 'purpose') = 'background' ifTrue: [  self top model backgroundColor: color ]

]

{ #category : #'as yet unclassified' }
BMSAXParser >> handleEndNode [
	| node |
	
	node := self pop.
	self top model children add: node.
	node model parent: self top.
	self canvas add: node.
	
	

]

{ #category : #'handling - content' }
BMSAXParser >> handleEndRoot [
	| endNode |
	
	endNode := self pop.
	self canvas mainTopic remove.
	self canvas mainTopic: endNode.
	self canvas add: endNode

]

{ #category : #'handling - content' }
BMSAXParser >> handleEndText [
	self top model text: stringBuilder.
	self stringBuilder: ''.

]

{ #category : #'handling - content' }
BMSAXParser >> handleFont: anAttributeDictionary [

	| font |
	
	font := LogicalFont 
		familyName: (anAttributeDictionary at: 'familyName')
		pointSize: (anAttributeDictionary at: 'pointSize') asFloatPoint 
		stretchValue: (anAttributeDictionary at: 'stretchValue') asFloatPoint 
		weightValue: (anAttributeDictionary at: 'weightValue') asFloatPoint 
		slantValue: (anAttributeDictionary at: 'slantValue') asFloatPoint.
		
	self top model font: font
	
]

{ #category : #'handling - content' }
BMSAXParser >> handleRootNode [
	| rootNode |
	
	rootNode := BMMainTopic new.
	self push: rootNode

]

{ #category : #initialization }
BMSAXParser >> initialize [
	super initialize.
	self 
		stack: Stack new;
		stringBuilder: ''

]

{ #category : #removing }
BMSAXParser >> pop [
	^self stack pop

]

{ #category : #adding }
BMSAXParser >> push: anObject [
	self stack push: anObject

]

{ #category : #accessing }
BMSAXParser >> stack [

	^ stack
]

{ #category : #accessing }
BMSAXParser >> stack: anObject [

	stack := anObject
]

{ #category : #'handling - content' }
BMSAXParser >> startDocument [ 
	self 
		stack: Stack new; 
		stringBuilder: ''

]

{ #category : #'handling - content' }
BMSAXParser >> startElement: aQualifiedName attributes: anAttributeDictionary [

	aQualifiedName = BMXMLTags rootNode ifTrue: [ self handleRootNode ].
	aQualifiedName = BMXMLTags childNode ifTrue: [ self handleChildNode ].
	aQualifiedName = BMXMLTags color ifTrue: [ self handleColor: anAttributeDictionary ].
	aQualifiedName = BMXMLTags font ifTrue: [ self handleFont: anAttributeDictionary ].
	aQualifiedName = BMXMLTags text ifTrue: [ self stringBuilder: '' ]

	
]

{ #category : #accessing }
BMSAXParser >> stringBuilder [

	^ stringBuilder
]

{ #category : #accessing }
BMSAXParser >> stringBuilder: anObject [

	stringBuilder := anObject
]

{ #category : #accessing }
BMSAXParser >> top [
	^self stack top 
]
