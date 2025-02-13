extends Panel

@export var abilityNameLabel : Label
@export var laborCountLabel : Label
@export var descriptionLabel : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BuildTree(self, 0)
	pass # Replace with function body.


func BuildTree(curr, depth):
	
	# Iterate through each child that is
	# a button and for each child connect a 
	# signal that unlocks the button of the 
	# next button 
	
	var children = curr.get_children()
	var count = curr.get_child_count()
	
	for i in count:
		var child = curr.get_child(i)
		
		if child is Button:
			
			# If parent is unlocked set active 
			if depth == 0: # Default nodes are always unlockable 
				child.disabled  = false; 
			elif curr.get_meta("Unlocked", false) == true: 
				child.disabled  = false;  
			else:
				child.disabled  = true;  
			
			
			var tabs = "";
			for t in depth:
				tabs += "   "
			
			print_debug(tabs + curr.name)
			BuildTree(child, depth + 1)
	

# Called by buttons when held down 
func UpdateChildrenEvent():
	pass 
