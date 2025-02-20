# The purpose of this script is to manage data used by developers
# Ideally is serves no purpose during a release build 

# TODO
# [ ] Manage audio 
# [ ] Create flag array 
# [ ] Make easier to update labors 
# [ ] Arbitrary file name variables 

@tool
extends Control

@export var trees : Array[Control]
@export var csvPath = "res://SkillTreeData/Sample.csv"

@export_category("Debug")
@export var GenerateToolset: bool:
	set(value):
		ToolsetGeneration()

@export var LoadSpreadsheetData: bool:
	set(value):
		DataLoad()

@export var ids : Array[int]

enum ValidNodeTypes
{
	BOOL 	= 0,
	STRING 	= 1,
	INT 	= 2,
	FLOAT 	= 3,
}


#region FileGeneration

# Generates a basic spreadsheet based on the children of the trees 
func ToolsetGeneration():
	
	# For each tree 
	#	Go through each button and generate a guid for it 
	#	Generate a line for the spreadsheet with default mandatory data 
	
	ids.clear()
	print_debug("Generating base csv...")
	var data : String 
	for tree in trees:
		data += RecurGenerateData(tree)
	
	print_debug("Base Data: [ID, Unlocked, AbilityName, LaborCount, LaborMax, Description, Cost]")
	print_debug()
	print_debug(data)
	WriteFile(data)


# Generates a spreadsheet based on the btn hierarchies 
func RecurGenerateData(curr):
	
	var childData = ""
	
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
				var unlocked 			= child.get_meta("Unlocked", false)
				var abilityName 		= child.get_meta("AbilityName", "abilityName") 
				var laborCount 			= child.get_meta("LaborCount", 0) 
				var laborMax 			= child.get_meta("LaborMax", 1) 
				var abilityDescription 	= child.get_meta("Description", "abilityDescription") 
				var cost 				= child.get_meta("Cost", 0.0) 
				
				# Generate a single line entry 
				nodeData.push_back(GenerateDataChunk(ValidNodeTypes.INT, "id", id))
				nodeData.push_back(GenerateDataChunk(ValidNodeTypes.BOOL, "Unlocked", unlocked))
				nodeData.push_back(GenerateDataChunk(ValidNodeTypes.STRING, "AbilityName", abilityName))
				nodeData.push_back(GenerateDataChunk(ValidNodeTypes.INT, "LaborCount", laborCount))
				nodeData.push_back(GenerateDataChunk(ValidNodeTypes.INT, "LaborMax", laborMax))
				nodeData.push_back(GenerateDataChunk(ValidNodeTypes.STRING, "Description", abilityDescription))
				nodeData.push_back(GenerateDataChunk(ValidNodeTypes.FLOAT, "Cost", cost))
				
				# TODO: Add id to ResourceUID to avoid repeat 
				
				# Adds current child data along its children info 
				childData += ",".join(nodeData) + "\n" 
				childData += RecurGenerateData(child)
	
	return childData

#endregion

#region DataLoading

# Initiates a read of the CSV data and loads
# it into metadata 
func DataLoad():
	
	var data = ReadFile()
	
	for tree in trees:
		RecurLoadData(tree, data)


# Loads the data into children recursively 
func RecurLoadData(curr, data : Array):
	
	# Load in spreadsheet data 
	# Iterate through each child of tree
	#	Search for ID in spreadsheet data
	#	if ID is present set data appropriatly 
	#		Remove ID for spreadsheet data list 
	
	for child in curr.get_children():
			
			RecurLoadData(child, data)
			
			# Ensure child is a clickable node 
			if child is Button:
				# Note that id is all lowercase for whatever reason
				var id = child.get_meta("id", -1)
				if id == -1:
					#push_error("ID is not available for " + child.get_name())
					return
				
				var i = 0 # Keep track of ID 
				# Search for id in data 
				for dLine in data:
					
					var chunk = ReadDataChunk("id", dLine)
					
					if id == chunk.data: 
						#print_debug("Found ID!")
						
						LoadIntoMeta(child, dLine)
						data.remove_at(i)
						break
					i += 1


# Loads line of spreadsheet data into the node's
# metadata 
func LoadIntoMeta(target, dataLine):
	
	
	var metaList = target.get_meta_list()
	#print_debug(metaList)
	
	for n in range(0, dataLine.size(), 3):
		var typeRaw 	= dataLine[n]
		var name 		= dataLine[n + 1]
		var dataRaw 	= dataLine[n + 2]  
		
		var contains = false 
		
		var i = 0
		for m in metaList:
			if (m == name):
				metaList.remove_at(i)
				break
			i += 1
		
		var converted = ConvertRaw(typeRaw, dataRaw)
		target.set_meta(name, converted.data)
	
	# Remove any metadata not accounted for  
	for m in metaList:
		target.remove_meta(m)
	

#endregion

#region ChunkManagement 

func GenerateDataChunk(type : int, name : String, data):
	var chunk : String
	
	match type:
		ValidNodeTypes.BOOL:
			chunk += "BOOL" + ","
			chunk += name + ","
			chunk += str(data)
		ValidNodeTypes.STRING:
			chunk += "STRING" + ","
			chunk += name + ","
			chunk += data
		ValidNodeTypes.INT:
			chunk += "INT" + ","
			chunk += name + ","
			chunk += str(data)
		ValidNodeTypes.FLOAT:
			chunk += "FLOAT" + ","
			chunk += name + ","
			chunk += str(data)
	
	return chunk


# Jump through the dataline to find valid name  
func ReadDataChunk(targetName : String, dataLine):
	# Complete base data operations 
	for n in range(1, dataLine.size(), 3):
		if targetName == dataLine[n]:
			
			# Raw string information 
			var typeRaw = dataLine[n - 1]
			var dataRaw = dataLine[n + 1]
			
			return ConvertRaw(typeRaw, dataRaw)
	
	return null


# Converts raw string type and int to their usable form 
func ConvertRaw(typeRaw : String, dataRaw : String):
	
	# Cleaned up data 
	var type
	var data 
	
	match typeRaw.strip_edges(true, true):
		"BOOL":
			type = ValidNodeTypes.BOOL
			data = dataRaw == "true"
		"STRING":
			type = ValidNodeTypes.STRING
			data = dataRaw 
		"INT":
			type = ValidNodeTypes.INT
			data = int(dataRaw)
		"FLOAT":
			type = ValidNodeTypes.FLOAT
			data = float(dataRaw)
	return { "type" : type, "data" : data }
	

#endregion 



# Writes a string to the desired file 
func WriteFile(content):
	var file = FileAccess.open(csvPath, FileAccess.WRITE)
	file.store_string(content)

# Get the data stored  
func ReadFile():
	
	var data : Array
	var file = FileAccess.open(csvPath, FileAccess.READ)
	
	print_debug("Loading data...")
	while !file.eof_reached():
		var content = file.get_csv_line()
		data.push_back(content)
		print_debug(content)
	
	return data 
