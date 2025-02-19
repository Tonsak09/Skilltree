extends Control

@export var treeSets : Array[Control]
@export var treeSetBtns : Array[Control]

var currSetID : int 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InitializeTrees()

# Initialize tree sets with their respective button 
func InitializeTrees():
	
	# Connect btn with treeSet 
	for i in treeSetBtns.size():
		
		# Check if within range 
		if i >= treeSets.size():
			treeSetBtns[i].disabled = true 
			continue
		
		# Set usabaility
		var tSet = treeSets[i]
		tSet.visible = false 
		treeSetBtns[i].disabled = false 
		
		# Link signal 
		#treeSetBtns[i].pressed.connect(ActivateTreeSet)
		treeSetBtns[i].InitData(self, i)
		
	
	# Set default to active 
	treeSets[0].visible = true 
	currSetID = 0

# Turns on a tree set and turns off current treeset 
func ActivateTreeSet(index : int):
	# Check if btn is on list 
	if index < 0:
		return
	
	# Confirm correlated with a treeSet 
	if index >= treeSets.size():
		return 
	
	# Swap visibility 
	treeSets[currSetID].visible = false 
	treeSets[index].visible = true 
	currSetID = index 

func GetCurretTreeSet():
	return treeSets[currSetID]
