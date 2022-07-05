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

"	| lineBuilder |
	
	lineBuilder := RSLineBuilder bezier.
	lineBuilder canvas: self canvas.
	lineBuilder withBorderAttachPoint.
	lineBuilder shapes: self canvas nodes.
	lineBuilder connectFrom: #parentModel.	 "
		RSForceBasedLayout new charge: -1000; on: self canvas nodes.
		self canvas zoomToFit.
		self canvas signalUpdate

]

{ #category : #'handling - content' }
BMSAXParser >> endElement: aQualifiedName [

	aQualifiedName = BMXMLTags text ifTrue: [ self handleEndText ].
	aQualifiedName = BMXMLTags detail ifTrue: [  self handleEndDetail ].
	aQualifiedName = BMXMLTags childNode ifTrue: [ self handleEndNode ].
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
		r: (anAttributeDictionary at: BMXMLTags red) asNumber
		g: (anAttributeDictionary at: BMXMLTags green) asNumber 
		b: (anAttributeDictionary at: BMXMLTags blue) asNumber 
		alpha: (anAttributeDictionary at: BMXMLTags alpha) asNumber.
		
	(anAttributeDictionary at: BMXMLTags purpose) = BMXMLTags foreground 
		ifTrue: [ self top model foreColor: color ].
		
	(anAttributeDictionary at: BMXMLTags purpose) = BMXMLTags background 
		ifTrue: [  self top model backgroundColor: color ]

]

{ #category : #'handling - content' }
BMSAXParser >> handleEndDetail [
	self top model details: stringBuilder.
	self stringBuilder: ''.

]

{ #category : #'handling - content' }
BMSAXParser >> handleEndNode [
	| node line|
	
	[ 
	node := self pop.
	self top model children add: node.
	node model parent: self top.
	self canvas add: node.
	
	node model children do: [ :child |
		line := RSBezier new.
		line 
			withBorderAttachPoint;
			from: node;
			to: child;
			controlPointsController: RSHorizontalCPAPController new.
		self canvas add: line]] on: CollectionIsEmpty do: [ ] 
	
	

]

{ #category : #'handling - content' }
BMSAXParser >> handleEndRoot [
	| endNode line|
	
	endNode := self pop.
	"self canvas mainTopic remove."
	self canvas mainTopic: endNode.
	self canvas add: endNode.
	endNode model children do: [ :child |
		line := RSBezier new.
		line 
			withBorderAttachPoint;
			from: endNode;
			to: child;
			controlPointsController: RSHorizontalCPAPController new.
		self canvas add: line]

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
		familyName: (anAttributeDictionary at: BMXMLTags familyName)
		pointSize: (anAttributeDictionary at: BMXMLTags pointSize) asNumber
		stretchValue: (anAttributeDictionary at: BMXMLTags stretchValue) asNumber
		weightValue: (anAttributeDictionary at: BMXMLTags weightValue) asNumber
		slantValue: (anAttributeDictionary at: BMXMLTags slantValue) asNumber.
		
	self top model font: font
	
]

{ #category : #'handling - content' }
BMSAXParser >> handleIcon: anAttributeDictionary [
	self top model addIcon: (anAttributeDictionary at: BMXMLTags iconAttribute) asSymbol  

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
	aQualifiedName = BMXMLTags text ifTrue: [ self stringBuilder: '' ].
	aQualifiedName = BMXMLTags detail ifTrue: [ self stringBuilder: '' ].
	aQualifiedName = BMXMLTags icon ifTrue: [ self handleIcon: anAttributeDictionary ]

	
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
