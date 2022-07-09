Extension { #name : #Color }

{ #category : #'*Bruce-Mindmap' }
Color >> bmWriteXMLTo: writer purpose: aString [
	| attributes |
	
	attributes := Dictionary 
		with: BMXMLTags red->self red asString 
		with: BMXMLTags green->self green asString
		with: BMXMLTags blue->self blue asString 
		with: BMXMLTags alpha->self alpha asString
		with: BMXMLTags purpose->aString.
		
	writer tag: BMXMLTags color attributes: attributes

]
