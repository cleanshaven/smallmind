Class {
	#name : #BMTaskModel,
	#superclass : #Object,
	#instVars : [
		'current'
	],
	#category : #'Bruce-Mindmap-model'
}

{ #category : #accessing }
BMTaskModel >> current [

	^ current
]

{ #category : #accessing }
BMTaskModel >> current: anObject [

	current := anObject
]

{ #category : #initialization }
BMTaskModel >> initialize [ 
	super initialize.
	current := #new
]

{ #category : #accessing }
BMTaskModel >> next [
	| index |
	
	index := self taskProgression indexOf: current.
	current := index = self taskProgression size
						ifTrue: [ self taskProgression at: 1 ]
						ifFalse: [  self taskProgression at: index + 1 ]
	
]

{ #category : #'as yet unclassified' }
BMTaskModel >> taskProgression [
	^#(#new #inprogress #onhold #done #cancel) asOrderedCollection

]

{ #category : #writing }
BMTaskModel >> writeToXML: writer [
	|attributes|
	
	attributes := Dictionary with: 'current'->self current asString.
	writer tag: 'task' attributes: attributes
]
