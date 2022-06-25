Class {
	#name : #BMNode,
	#superclass : #Object,
	#instVars : [
		'text',
		'font',
		'foreColor',
		'backgroundColor',
		'children'
	],
	#category : #'Bruce-Mindmap-model'
}

{ #category : #accessing }
BMNode >> backgroundColor [

	^ backgroundColor
]

{ #category : #accessing }
BMNode >> backgroundColor: anObject [

	backgroundColor := anObject
]

{ #category : #accessing }
BMNode >> children [

	^ children
]

{ #category : #accessing }
BMNode >> children: anObject [

	children := anObject
]

{ #category : #accessing }
BMNode >> font [

	^ font
]

{ #category : #accessing }
BMNode >> font: anObject [

	font := anObject
]

{ #category : #accessing }
BMNode >> foreColor [

	^ foreColor
]

{ #category : #accessing }
BMNode >> foreColor: anObject [

	foreColor := anObject
]

{ #category : #accessing }
BMNode >> text [

	^ text
]

{ #category : #accessing }
BMNode >> text: anObject [

	text := anObject
]
