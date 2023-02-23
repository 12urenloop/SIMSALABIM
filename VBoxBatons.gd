extends VBoxContainer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxStationFilter.connect("station_filter_changed", self, "_on_station_filter_changed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _on_station_filter_changed(enabled_stations):
	for child in $HBoxBatonList.get_children():
		child.get_node("ScrollBatonLogs").get_node("MarginContainer").get_node("GridContainer").enabled_stations = enabled_stations
