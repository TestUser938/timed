extends Node


func save_time(value: float):
	var config = ConfigFile.new()
	config.set_value("data", "best_time", value)
	config.save("user://save_data.cfg")

func load_time() -> float:
	var config = ConfigFile.new()
	var err = config.load("user://save_data.cfg")
	if err == OK:
		return config.get_value("data", "best_time", 0.0)
	return 0.0 # Default value if no save exists
