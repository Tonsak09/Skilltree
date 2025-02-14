extends Panel

@export var abilityNameLabel : Label
@export var laborCountLabel : Label
@export var descriptionLabel : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BuildTree(self, 0)
	pass # Replace with function body.


# Set buttons active based on parent unlocked 
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
			
			child.Init(self)
			var tabs = "";
			for t in depth:
				tabs += "   "
			
			BuildTree(child, depth + 1)

# Updates upgrade info based on metadata 
func DisplayDesc(upgradeBtn : Button):
	abilityNameLabel.text = upgradeBtn.get_meta("AbilityName")
	laborCountLabel.text = "USED: " + str(upgradeBtn.get_meta("LaborCount")) + "/" + str(upgradeBtn.get_meta("LaborMax"))
	descriptionLabel.text = upgradeBtn.get_meta("Description")

# Updates unlock metadata 
func UnlockUpgrade(upgradeBtn : Button):
	pass 
