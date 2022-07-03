Class {
	#name : #BMClipboardParser,
	#superclass : #BMSAXParser,
	#instVars : [
		'lastNode',
		'parentNode'
	],
	#category : #'Bruce-Mindmap-SAX'
}

{ #category : #'handling - content' }
BMClipboardParser >> endDocument [ 
   |line|
	
	parentNode model children add: lastNode.
	lastNode model parent: parentNode.
	self canvas add: lastNode.
	line := RSBezier  new.
			line 
			withBorderAttachPoint;
			from: parentNode;
			to: lastNode;
			controlPointsController: RSHorizontalCPAPController new.
		self canvas add: line.
	lastNode model children do: [ :child |
	line := RSBezier  new.
			line 
			withBorderAttachPoint;
			from: lastNode;
			to: child;
			controlPointsController: RSHorizontalCPAPController new.
		self canvas add: line.
		 ].
	super endDocument

]

{ #category : #'handling - content' }
BMClipboardParser >> handleEndNode [ 
	| node line |
	
	node := self pop.
	self isStackEmpty ifFalse: [ 
		self top model children add: node.
		node model parent: self top ].
	self canvas add: node.
		node model children do: [ :child |
			line := RSBezier new.
			line 
				withBorderAttachPoint;
				from: node;
				to: child;
				controlPointsController: RSHorizontalCPAPController new.
			self canvas add: line ]

]

{ #category : #testing }
BMClipboardParser >> isStackEmpty [
	^self stack isEmpty

]

{ #category : #accessing }
BMClipboardParser >> lastNode [

	^ lastNode
]

{ #category : #accessing }
BMClipboardParser >> lastNode: anObject [

	lastNode := anObject
]

{ #category : #accessing }
BMClipboardParser >> parentNode [

	^ parentNode
]

{ #category : #accessing }
BMClipboardParser >> parentNode: anObject [

	parentNode := anObject
]

{ #category : #removing }
BMClipboardParser >> pop [ 
	| node |
	node := super pop.
	self lastNode: node.
	^node

]

{ #category : #'handling - content' }
BMClipboardParser >> startDocument [ 
	super startDocument.
	self push: parentNode
]
