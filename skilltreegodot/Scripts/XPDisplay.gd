extends MarginContainer

@export var sectionSelection : Control 
@export var upgradeBar : ColorRect



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var currBtn = sectionSelection.GetCurretTreeSet().currBtn 
	if currBtn == null:
		return 
	
	upgradeBar.material.set_shader_parameter("UpgradeT", currBtn.GetInterpToUpgrade())
