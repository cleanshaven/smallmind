Class {
	#name : #BMApplication,
	#superclass : #SpApplication,
	#category : #'Bruce-Mindmap-spec'
}

{ #category : #accessing }
BMApplication >> start [ 
	^(self new: BMPresenter) open
]
