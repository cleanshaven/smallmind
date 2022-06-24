Class {
	#name : #BMPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'spCanvas'
	],
	#category : #'Bruce-Mindmap-spec'
}

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
