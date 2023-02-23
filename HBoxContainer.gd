extends HBoxContainer

signal station_filter_changed(enabled_stations)

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var enabled_stations = Array()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for station in get_tree().get_nodes_in_group("station_root"):
		var checkButton = CheckButton.new()
		checkButton.text = station.name
		checkButton.pressed = true
		checkButton.connect("toggled", self, "_on_station_filter_toggled", [station])
		enabled_stations.append(station.name)
		add_child(checkButton)
		
func _on_station_filter_toggled(is_toggled, station):
	if is_toggled:
		enabled_stations.append(station.name)
	else:
		enabled_stations.erase(station.name)
		
	emit_signal("station_filter_changed", enabled_stations)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
