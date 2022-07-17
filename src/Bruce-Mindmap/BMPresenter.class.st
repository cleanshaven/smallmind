Class {
	#name : #BMPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'spCanvas'
	],
	#category : #'Bruce-Mindmap-spec'
}

{ #category : #initialization }
BMPresenter >> connectPresenters [ 
	self spCanvas canvas: (BMCanvas new application: self application; yourself).
	
	self application when: BMFileChanged do: [ :evt | 
		self withWindowDo: [ :w | w title: 'Small Mind: ',evt newData ] ].
	
	self application when: BMUnsavedChange do: [ :evt |
		self withWindowDo: [ :w | w title: 'Small Mind', 
			(application filename isEmptyOrNil ifFalse: [': ', application filename ] ifTrue:['']) , '*' ]]
	
	

]

{ #category : #layout }
BMPresenter >> defaultLayout [
	^SpBoxLayout newTopToBottom 
		add: #spCanvas;
		yourself
	

]

{ #category : #initialization }
BMPresenter >> initializePresenters [ 
	super initializePresenters.
	self spCanvas: self newRoassal.

]

{ #category : #initialization }
BMPresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'Small Mind';
		initialExtent: 1000@1000;
		windowIcon: (self iconNamed: #bmAppIcon)
		
]

{ #category : #accessing }
BMPresenter >> spCanvas [

	^ spCanvas
]

{ #category : #accessing }
BMPresenter >> spCanvas: anObject [

	spCanvas := anObject
]
