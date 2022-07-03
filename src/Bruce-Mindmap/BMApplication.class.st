Class {
	#name : #BMApplication,
	#superclass : #SpApplication,
	#classInstVars : [
		'clipboard'
	],
	#category : #'Bruce-Mindmap-spec'
}

{ #category : #accessing }
BMApplication class >> clipboard [

	^ clipboard
]

{ #category : #accessing }
BMApplication class >> clipboard: anObject [

	clipboard := anObject
]

{ #category : #accessing }
BMApplication >> start [ 
	^(self new: BMPresenter) open
]
