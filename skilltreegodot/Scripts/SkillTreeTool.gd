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
		pass
		#WriteFile(sampleData)

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


func RecurGenerateData(curr):
	
	for child in curr.get_children():
			# Ensure child is a clickable node 
			if child is Button:
				var nodeData : PackedStringArray
			
				# Generate GUID
				# Note that we are not registering to a resource
				# since we are managing our nodes outside of GODOT 
				var id = ResourceUID.create_id()
				var unlocked = false 
				var abilityName = "abilityName"
				var laborCount = 0
				var laborMax = 1
				var abilityDescription = "abilityDescription"
				
				nodeData.push_back(str(id / 10000))
				nodeData.push_back(str(unlocked))
				nodeData.push_back(abilityName)
				nodeData.push_back(str(laborCount))
				nodeData.push_back(str(laborMax))
				nodeData.push_back(abilityDescription)
				
				# TODO: Add id to ResourceUID to avoid repeat 
				
				return ",".join(nodeData) + "\n" + RecurGenerateData(child)
				
				WriteFile(nodeData)
	return ""


func WriteFile(content):
	var file = FileAccess.open("res://SkillTreeData/Sample.csv", FileAccess.WRITE)
	file.store_string(content)
	#file.store_csv_line(content)

func ReadFile():
	var file = FileAccess.open("res://SkillTreeData/Sample.csv", FileAccess.READ)
	while !file.eof_reached():
		var content = file.get_csv_line()
