extends Node

func generate_reward_technique_pool(charName : String) -> Array[TechniqueData]:
	var techniquePool : Array[TechniqueData] = []
	var directoryName : String = "res://Characters/" + charName.to_lower() + "/techniques"
	var dir = DirAccess.open(directoryName)
	if dir:
		var techniqueFiles = dir.get_files()
		if techniqueFiles.size() > 0:
			for techniqueFile in techniqueFiles:
				if ".tres" in techniqueFile and "_baseatk.tres" not in techniqueFile:
					var loadedFile = load(directoryName + "/" + techniqueFile)
					if loadedFile is TechniqueData:
						techniquePool.append(loadedFile)
	return techniquePool

func reward_technique(charName : String):
	var techniquePool : Array[TechniqueData] = generate_reward_technique_pool(charName)
	var randomIndex : int = randi() % techniquePool.size()
	if CurrentRunData.technique_inventory != null:
		CurrentRunData.technique_inventory.add(techniquePool[randomIndex])
