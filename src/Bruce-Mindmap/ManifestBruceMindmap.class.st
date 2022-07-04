"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestBruceMindmap,
	#superclass : #PackageManifest,
	#category : #'Bruce-Mindmap-Manifest'
}

{ #category : #'code-critics' }
ManifestBruceMindmap class >> ruleCollectionProtocolRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#BMClipboardParser #endDocument #false)) #'2022-07-03T09:12:29.641519-04:00') #(#(#RGMethodDefinition #(#BMClipboardParser #handleEndNode #false)) #'2022-07-03T09:31:49.653447-04:00') #(#(#RGMethodDefinition #(#BMTopic #modelChanged: #false)) #'2022-07-04T16:05:34.414914-04:00') )
]

{ #category : #'code-critics' }
ManifestBruceMindmap class >> ruleReGuardClauseRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#BMNode #addIcon: #false)) #'2022-07-04T09:32:57.763835-04:00') )
]
