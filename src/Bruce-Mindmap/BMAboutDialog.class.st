Class {
	#name : #BMAboutDialog,
	#superclass : #SpPresenter,
	#instVars : [
		'explanation'
	],
	#category : #'Bruce-Mindmap-dialogs'
}

{ #category : #accessing }
BMAboutDialog >> content [
	^'Simple Mind\\A Mindmapping Application\\Author: Bruce Haugland' withCRs
]

{ #category : #layout }
BMAboutDialog >> defaultLayout [ 

	^SpBoxLayout newTopToBottom
		add: explanation;
		yourself
]

{ #category : #initialization }
BMAboutDialog >> initializeDialogWindow: aDialog [

	aDialog 
		title: 'About Simple Mind';
		closeOnBackdropClick: false;
		addButton: 'OK'
			do: [ : presenter | presenter close ]
]

{ #category : #initialization }
BMAboutDialog >> initializePresenters [ 
	explanation := self newText beNotEditable; yourself.
	
	explanation text: self content
]
