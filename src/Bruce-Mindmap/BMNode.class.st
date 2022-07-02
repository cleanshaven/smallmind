Class {
	#name : #BMNode,
	#superclass : #Object,
	#instVars : [
		'text',
		'font',
		'foreColor',
		'backgroundColor',
		'children',
		'parent',
		'announcer',
		'details'
	],
	#category : #'Bruce-Mindmap-model'
}

{ #category : #announcer }
BMNode >> announce: anAnnouncement [

	self announcer announce: anAnnouncement.
	

]

{ #category : #accessing }
BMNode >> announcer [

	^ announcer
]

{ #category : #accessing }
BMNode >> announcer: anObject [

	announcer := anObject
]

{ #category : #accessing }
BMNode >> backgroundColor [

	^ backgroundColor
]

{ #category : #accessing }
BMNode >> backgroundColor: anObject [

	backgroundColor := anObject.
	self announce: (BMAnnounceBackgroundColorChanged new newData: anObject; yourself)
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
BMNode >> details [

	^ details
]

{ #category : #accessing }
BMNode >> details: anObject [

	details := anObject
]

{ #category : #accessing }
BMNode >> font [

	^ font
]

{ #category : #accessing }
BMNode >> font: anObject [

	font := anObject.
	self announce: (BMAnnounceFontChanged new newData: anObject; yourself)
]

{ #category : #accessing }
BMNode >> foreColor [

	^ foreColor
]

{ #category : #accessing }
BMNode >> foreColor: anObject [

	foreColor := anObject.
	self announce: (BMAnnounceForeColorChanged new newData: anObject; yourself)
]

{ #category : #initialization }
BMNode >> initialize [ 
	super initialize.
	self children: OrderedCollection new.
	self announcer: Announcer new.
	self details: ''

]

{ #category : #accessing }
BMNode >> parent [

	^ parent
]

{ #category : #accessing }
BMNode >> parent: anObject [

	parent := anObject
]

{ #category : #accessing }
BMNode >> parentModel [
	^self parentModel

]

{ #category : #accessing }
BMNode >> text [

	^ text
]

{ #category : #accessing }
BMNode >> text: anObject [

	text := anObject.
	self announce: (BMAnnounceTextChanged new newData: anObject; yourself)
]

{ #category : #announcer }
BMNode >> when: anAnnouncement do: aValueable [
	self announcer when: anAnnouncement do: aValueable

]
