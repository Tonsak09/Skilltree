extends Button

@export var timeToUnlock : float 

# Used to update information facing user 
var treeManager : Control 

var held : bool
var heldTime : float 

func _init() -> void:
	held = false 

func _process(delta: float) -> void:
	
	if get_meta("Unlocked") == false && held == true:
		heldTime = clampf((heldTime + delta if held else -delta), 0.0, timeToUnlock) 
		
		print_debug(heldTime)
		
		# Able to unlock yet? 
		if(heldTime >= timeToUnlock):
			
			# Update metadata 
			set_meta("Unlocked", true)
			
			# Turn children clickable  
			for child in get_children():
				if child is Button: 
					child.disabled = false 
			
	else:
		pass

# Called to initilize by tree 
func Init(tm : Control):
	treeManager = tm

# Single click on node to view information 
func UpgradeClick():
	treeManager.DisplayDesc(self)

# Holds to begin unlocking node 
func UpgradeHold():
	# TODO: Unlock over delta time 
	treeManager.UnlockUpgrade(self) 
	
	held = true 

# No longer holding upgrade down 
func UpgradeUp():
	held = false 
