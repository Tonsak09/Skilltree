# The purpose of this script is to manage the visuals of this node 

extends Button

@export_category("Visual Settings")
@export var iconTexture : Texture
@export var videoDemo : VideoStreamTheora
@export var timeToUnlock : float 
@export var upgradeCurve : Curve

@export_category("Reference Nodes")
@export var nodeBG : ColorRect
@export var nodeIcon : TextureRect

# Used to update information facing user 
var treeManager : Control 

var held : bool
var heldTime : float 

func _init() -> void:
	held = false 
	if iconTexture != null:
		nodeIcon.texture = iconTexture

func _process(delta: float) -> void:
	
	# Ensure it is affordable 
	if get_meta("Cost", 0.0) > PlayerResources.xp:
		if get_meta("Unlocked"):
			nodeBG.material.set_shader_parameter("Height", 1.0)
		else:
			nodeBG.material.set_shader_parameter("Height", 0.0)
		
		return 
	
	if !get_meta("Unlocked"):
		heldTime = clampf((heldTime + delta if held else heldTime - delta), 0.0, timeToUnlock) 
		
		var t = heldTime / timeToUnlock
		nodeBG.material.set_shader_parameter("Height", upgradeCurve.sample(t))
	
	# Confirm this is not yet unlocked 
	if get_meta("Unlocked") == false && held == true:
		# Able to unlock yet? 
		if(heldTime >= timeToUnlock):
			
			# Update metadata 
			set_meta("Unlocked", true)
			
			# Reduce xp 
			PlayerResources.xp -= get_meta("Cost", 0.0)
			
			# Turn children clickable 
			for child in get_children():
				if child is Button: 
					child.SetActive()
	
	

# Turns this node ON 
func SetActive():
	disabled = false 
	nodeIcon.material.set_shader_parameter("Alpha", 1.0)

# Called to initilize by tree 
func Init(tm : Control):
	treeManager = tm
	
	if disabled:
		nodeIcon.material.set_shader_parameter("Alpha", 0.5)
	else:
		nodeIcon.material.set_shader_parameter("Alpha", 1.0)
	

# Single click on node to view information 
func UpgradeClick():
	treeManager.DisplayDesc(self)
	treeManager.UpdateCurrentBtn(self)

# Holds to begin unlocking node 
func UpgradeHold():
	held = true 
	treeManager.DisplayDesc(self)
	treeManager.UpdateCurrentBtn(self)

# No longer holding upgrade down 
func UpgradeUp():
	held = false 

func GetInterpToUpgrade():
	return heldTime / timeToUnlock
	
