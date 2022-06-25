Class {
	#name : #BMTopic,
	#superclass : #RSComposite,
	#instVars : [
		'label'
	],
	#category : #'Bruce-Mindmap-roassal'
}

{ #category : #initialization }
BMTopic >> createMenu [

	self @ (RSMenuActivable new
		menuDo: [ :menu :box | 
			menu 
				add: 'Add Child' target: box selector: #addChild argument: #();
				add: 'AddSibling' target: box selector: #addSibling argument: #();
				add: 'Edit' target: box selector: #editText argument: #();
				add: 'Color' target: box selector: #editColor argument: #();
				add: 'Font' target: box selector: #editFont argument: #();
				addLine;
				add: 'Delete' target: box selector: #deleteNode argument: #()
				 ])
]

{ #category : #'announcement handling' }
BMTopic >> fontChanged: aFont [
	self label font: aFont.
	self updateCanvas
]

{ #category : #'announcement handling' }
BMTopic >> foreColorChanged: aColor [
	self label color: aColor.
	self updateCanvas

]

{ #category : #initialization }
BMTopic >> initialize [ 
	super initialize.
	self model: BMNode new.
	self model when: BMAnnounceTextChanged do: [ :announcement | self labelChanged: announcement newData ].
	self model when: BMAnnounceFontChanged  do: [ :announcement | self fontChanged: announcement newData ].
	self model when: BMAnnounceForeColorChanged do: [ :announcement | self foreColorChanged: announcement newData ].
	self color: Color transparent.
	self label: RSLabel new.
	self add: label.
	self draggable.
	self createMenu.

]

{ #category : #accessing }
BMTopic >> label [

	^ label
]

{ #category : #accessing }
BMTopic >> label: anObject [

	label := anObject
]

{ #category : #'announcement handling' }
BMTopic >> labelChanged: aString [
	self label text: aString.
	self updateCanvas

]

{ #category : #'private ' }
BMTopic >> updateCanvas [
	self canvas ifNotNil: [ self canvas signalUpdate ]
]
