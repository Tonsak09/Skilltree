# The purpose of this script is to manage data used by developers
# Ideally is serves no purpose during a release build 

@tool
extends Control

@export var trees : Array[Control]

@export_category("Debug")
@export var GenerateToolset: bool:
	set(value):
		ToolsetGeneration()

@export var LoadSpreadsheetData: bool:
	set(value):
		DataLoad()

@export var ids : Array[int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ReadFile()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		pass

# Generates a basic spreadsheet based on the children of the trees 
func ToolsetGeneration():
	
	# For each tree 
	#	Go through each button and generate a guid for it 
	#	Generate a line for the spreadsheet with default mandatory data 
	
	var data : String 
	for tree in trees:
		data += RecurGenerateData(tree)
	
	WriteFile(data)


func DataLoad():
	for tree in trees:
		RecurLoadData(tree)

# Generates a spreadsheet based on the btn hierarchies 
func RecurGenerateData(curr):
	
	for child in curr.get_children():
			# Ensure child is a clickable node 
			if child is Button:
				var nodeData : PackedStringArray
			
				# Generate GUID
				# Note that we are not registering to a resource
				# since we are managing our data outside of GODOT 
				var id = ResourceUID.create_id() / 10000
				
				# TODO: Optimize this check 
				while ids.has(id):
					id = ResourceUID.create_id() / 10000
				ids.push_back(id)
				child.set_meta("id", id)
				
				# Uses metadata of btn is avaliable otherwise adds it manually 
				var unlocked = child.get_meta("Unlocked", false)
				var abilityName = child.get_meta("AbilityName", "abilityName") 
				var laborCount = child.get_meta("LaborCount", 0) 
				var laborMax = child.get_meta("LaborMax", 1) 
				var abilityDescription = child.get_meta("Description", "abilityDescription") 
				
				nodeData.push_back(str(id))
				nodeData.push_back(str(unlocked))
				nodeData.push_back(abilityName)
				nodeData.push_back(str(laborCount))
				nodeData.push_back(str(laborMax))
				nodeData.push_back(abilityDescription)
				
				# TODO: Add id to ResourceUID to avoid repeat 
				
				return ",".join(nodeData) + "\n" + RecurGenerateData(child)
				
				WriteFile(nodeData)
	return ""


func RecurLoadData(curr):
	
	# Load in spreadsheet data 
	# Iterate through each child of tree
	#	Search for ID in spreadsheet data
	#	if ID is present set data appropriatly 
	#		Remove ID for spreadsheet data list 
	ReadFile()
	pass 

func WriteFile(content):
	var file = FileAccess.open("res://SkillTreeData/Sample.csv", FileAccess.WRITE)
	file.store_string(content)
	#file.store_csv_line(content)

func ReadFile():
	
	var data : Array
	var file = FileAccess.open("res://SkillTreeData/Sample.csv", FileAccess.READ)
	while !file.eof_reached():
		var content = file.get_csv_line()
		data.push_back(content)
	
