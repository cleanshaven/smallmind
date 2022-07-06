Class {
	#name : #BMApplication,
	#superclass : #SpApplication,
	#classInstVars : [
		'clipboard',
		'icons'
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
BMApplication class >> icons [

	^ icons
]

{ #category : #accessing }
BMApplication class >> icons: anObject [

	icons := anObject
]

{ #category : #initialization }
BMApplication class >> initialize [
	| stream themeIcons|
	
	themeIcons := ThemeIcons current.
	stream := '/home/bruce/Pictures/note.png' asFileReference.
	themeIcons icons at: #detailIcon put: (themeIcons readPNGFrom: stream).
	stream := '/home/bruce/Pictures/weblink.png' asFileReference.
	themeIcons icons at: #weblinkIcon put: (themeIcons readPNGFrom: stream).

	
	
	

]

{ #category : #accessing }
BMApplication >> start [ 
	^(self new: BMPresenter) open
]
