extends Control

@export var abilityNameLabel : Label
@export var descriptionLabel : Label

@export var laborContainer : Control 
@export var laborCountLabel : Label

@export var xpContainer : Control
@export var xpLabel : Label 

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
			
			# TODO: Pass in meta data here 
			child.Init(self)
			
			var tabs = "";
			for t in depth:
				tabs += "   "
			
			BuildTree(child, depth + 1)

# Updates upgrade info based on metadata 
func DisplayDesc(upgradeBtn : Button):
	abilityNameLabel.text = upgradeBtn.get_meta("AbilityName")
	
	if upgradeBtn.get_meta("Unlocked"):
		xpContainer.visible = false
		laborContainer.visible = true 
		laborCountLabel.text = "USED: " + str(upgradeBtn.get_meta("LaborCount")) + "/" + str(upgradeBtn.get_meta("LaborMax"))
	else:
		laborContainer.visible = false 
		xpContainer.visible = true 
		xpLabel.text = str(upgradeBtn.get_meta("Cost")) + "/" + str(PlayerResources.xp)
		
	
	descriptionLabel.text = upgradeBtn.get_meta("Description")

# Updates the treeset what the current btn is 
func UpdateCurrentBtn(btn : Button):
	get_parent().currBtn = btn
