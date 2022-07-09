Extension { #name : #LogicalFont }

{ #category : #'*Bruce-Mindmap' }
LogicalFont >> bmWriteXMLTo: writer [
	| attributes |
	
	attributes := Dictionary 
		with: BMXMLTags pointSize->self pointSize asString
		with: BMXMLTags familyName->self familyName asString
		with: BMXMLTags stretchValue->self stretchValue asString 
		with: BMXMLTags weightValue->self weightValue asString
		with: BMXMLTags slantValue->self slantValue asString.
		
	writer tag: BMXMLTags font attributes: attributes 

]
