Class {
	#name : #BMApplication,
	#superclass : #SpApplication,
	#instVars : [
		'filename',
		'announcer'
	],
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

{ #category : #announcer }
BMApplication >> announce: anAnnouncement [

	self announcer announce: anAnnouncement.

]

{ #category : #accessing }
BMApplication >> announcer [

	^ announcer
]

{ #category : #accessing }
BMApplication >> announcer: anObject [

	announcer := anObject
]

{ #category : #accessing }
BMApplication >> filename [

	^ filename
]

{ #category : #accessing }
BMApplication >> filename: anObject [

	filename := anObject.
	self announce: (BMFileChanged new newData: anObject)
]

{ #category : #initialization }
BMApplication >> initialize [ 
	super initialize.
	self announcer: Announcer new
]

{ #category : #initialization }
BMApplication >> modelChanged [ 
	self announce: BMUnsavedChange new.

]

{ #category : #accessing }
BMApplication >> start [ 
	^(self new: BMPresenter) open
]

{ #category : #announcer }
BMApplication >> when: anAnnouncement do: aValueable [
	self announcer when: anAnnouncement do: aValueable

]
