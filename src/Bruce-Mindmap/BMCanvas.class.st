Class {
	#name : #BMCanvas,
	#superclass : #RSCanvas,
	#instVars : [
		'mainTopic'
	],
	#category : #'Bruce-Mindmap-roassal'
}

{ #category : #removing }
BMCanvas >> clear [
	self removeAllChildren: mainTopic.
	self mainTopic: nil
]

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

{ #category : #removing }
BMCanvas >> removeAllChildren: aNode [
	aNode model children do: [ :child | self removeAllChildren: child ].
	aNode remove
]
