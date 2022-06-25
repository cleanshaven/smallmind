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
	self spCanvas canvas: BMCanvas new

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

{ #category : #accessing }
BMPresenter >> spCanvas [

	^ spCanvas
]

{ #category : #accessing }
BMPresenter >> spCanvas: anObject [

	spCanvas := anObject
]
