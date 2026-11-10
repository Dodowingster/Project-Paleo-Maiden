extends Node

func generate_reward_technique_pool(char_name : String) -> Array[TechniqueData]:
	var technique_pool : Array[TechniqueData] = []
	var directory_name : String = "res://Characters/" + char_name.to_lower() + "/techniques"
	var dir = DirAccess.open(directory_name)
	if dir:
		var technique_files = dir.get_files()
		if technique_files.size() > 0:
			for technique_file in technique_files:
				if ".tres" in technique_file and "_baseatk.tres" not in technique_file:
					var loadedFile = load(directory_name + "/" + technique_file)
					if loadedFile is TechniqueData:
						technique_pool.append(loadedFile)
	return technique_pool

func reward_technique(char_name : String):
	var technique_pool : Array[TechniqueData] = generate_reward_technique_pool(char_name)
	var random_index : int = randi() % technique_pool.size()
	if CurrentRunData.technique_inventory != null:
		CurrentRunData.technique_inventory.add(technique_pool[random_index])
