Class {
	#name : #BMWorldMenu,
	#superclass : #Object,
	#category : #'Bruce-Mindmap-menu'
}

{ #category : #menu }
BMWorldMenu class >> menuNewMindMapOn: aBuilder [
	<worldMenu>
	(aBuilder item: #NewMindMap)
		parent: #Tools;
		label: 'New MindMap';
		help: 'Create a new MindMap';
		order: 10;
		icon: (ThemeIcons current icons at: #bmAppIcon);
		action: [ BMApplication new start ]
		
	
]
