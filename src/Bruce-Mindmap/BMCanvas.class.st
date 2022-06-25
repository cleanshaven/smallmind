Class {
	#name : #BMCanvas,
	#superclass : #RSCanvas,
	#instVars : [
		'mainTopic'
	],
	#category : #'Bruce-Mindmap-roassal'
}

{ #category : #initialization }
BMCanvas >> initialize [ 
	super initialize.
	self mainTopic: BMMainTopic new.
	self add: self mainTopic. 
	self @ RSCanvasController

]

{ #category : #accessing }
BMCanvas >> mainTopic [

	^ mainTopic
]

{ #category : #accessing }
BMCanvas >> mainTopic: anObject [

	mainTopic := anObject
]
