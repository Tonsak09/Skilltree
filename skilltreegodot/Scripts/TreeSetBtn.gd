extends Button

var sectionSelection : Control
var index : int

func _ready() -> void:
	disabled = true 
	index = -1 

func InitData(ss : Control, id : int):
	sectionSelection = ss  
	index = id 


func OnPress():
	sectionSelection.ActivateTreeSet(index)
