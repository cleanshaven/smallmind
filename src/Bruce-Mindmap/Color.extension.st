Extension { #name : #Color }

{ #category : #'*Bruce-Mindmap' }
Color >> bmWriteXMLTo: writer purpose: aString [
	| attributes |
	
	attributes := Dictionary 
		with: 'red'->self red asString 
		with: 'green'->self green asString
		with: 'blue'->self blue asString 
		with: 'alpha'->self alpha asString
		with: 'pupose'->aString.
		
	writer tag: BMXMLTags color attributes: attributes

]
