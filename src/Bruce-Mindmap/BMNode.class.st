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
		'details',
		'icons',
		'link',
		'image',
		'task'
	],
	#category : #'Bruce-Mindmap-model'
}

{ #category : #accessing }
BMNode >> addIcon: aSymbol [

	(self icons findFirst: [:each | each = aSymbol]) = 0
		ifTrue: [ 
			self icons add: aSymbol.
			self announce: (BMModelChanged new newData: self; yourself)
		]
]

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
	self announce: (BMModelChanged new newData: self; yourself)
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

	details := anObject.

	
]

{ #category : #accessing }
BMNode >> font [

	^ font
]

{ #category : #accessing }
BMNode >> font: anObject [

	font := anObject.
	self announce: (BMModelChanged new newData: self; yourself)
]

{ #category : #accessing }
BMNode >> foreColor [

	^ foreColor
]

{ #category : #accessing }
BMNode >> foreColor: anObject [

	foreColor := anObject.
	self announce: (BMModelChanged new newData: self; yourself)
]

{ #category : #accessing }
BMNode >> icons [

	^ icons
]

{ #category : #accessing }
BMNode >> icons: anObject [

	icons := anObject
]

{ #category : #accessing }
BMNode >> image [

	^ image
]

{ #category : #accessing }
BMNode >> image: anObject [

	image := anObject.
	self announce: (BMModelChanged new newData: self; yourself)
]

{ #category : #initialization }
BMNode >> initialize [ 
	super initialize.
	self children: OrderedCollection new.
	self announcer: Announcer new.
	self icons: OrderedCollection new.
	self task: BMTaskModel new.

	self details: ''

]

{ #category : #accessing }
BMNode >> link [

	^ link
]

{ #category : #accessing }
BMNode >> link: anObject [

	link := anObject
]

{ #category : #'as yet unclassified' }
BMNode >> nextTask [
	self task next.
	self announce: (BMModelChanged new newData: self; yourself) 
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

{ #category : #removing }
BMNode >> removeAllTaskIcons [

	#(#bmCancelIcon #bmCompleteIcon #bmInProcessIcon #bmOnHoldIcon) do: [ :icon | self removeIcon: icon ]
]

{ #category : #accessing }
BMNode >> removeIcon: aSymbol [
	self icons remove: aSymbol ifAbsent: [ ^self ].
	self announce: (BMModelChanged new newData: self; yourself)
]

{ #category : #accessing }
BMNode >> task [

	task ifNil: [ task := BMTaskModel new ].
	^ task
]

{ #category : #accessing }
BMNode >> task: anObject [

	task := anObject
]

{ #category : #accessing }
BMNode >> text [

	^ text
]

{ #category : #accessing }
BMNode >> text: anObject [

	text := anObject.
	self announce: (BMModelChanged new newData: self; yourself)
]

{ #category : #announcer }
BMNode >> when: anAnnouncement do: aValueable [
	self announcer when: anAnnouncement do: aValueable

]
