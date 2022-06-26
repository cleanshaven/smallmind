Extension { #name : #LogicalFont }

{ #category : #'*Bruce-Mindmap' }
LogicalFont >> bmWriteXMLTo: writer [
	| attributes |
	
	attributes := Dictionary 
		with: 'pointSize'->self pointSize asString
		with: 'familyName'->self familyName asString
		with: 'stretchValue'->self stretchValue asString 
		with: 'weightValue'->self weightValue asString
		with: 'slantValue'->self slantValue asString.
		
	writer tag: BMXMLTags font attributes: attributes 

]
