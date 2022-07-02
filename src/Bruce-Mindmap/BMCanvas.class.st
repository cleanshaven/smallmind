Class {
	#name : #BMCanvas,
	#superclass : #RSCanvas,
	#instVars : [
		'mainTopic',
		'application'
	],
	#category : #'Bruce-Mindmap-roassal'
}

{ #category : #accessing }
BMCanvas >> application [

	^ application
]

{ #category : #accessing }
BMCanvas >> application: anObject [

	application := anObject
]

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
