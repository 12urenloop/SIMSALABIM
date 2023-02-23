extends GridContainer

var selected_baton = 'Baton'

var enabled_stations = []

func _ready() -> void:
	for baton in get_tree().get_nodes_in_group("baton_root"):
		if baton.name == selected_baton:
			baton.connect("detection_registered", self, "_on_detection_registered")

func _on_detection_registered(station, rssi, timestamp):
	if enabled_stations.has(station.name):
		$NameValues.text += selected_baton
		$NameValues.text += '\n'
		$StationValues.text += station.name
		$StationValues.text += '\n'
		$RssiValues.text += str(rssi)
		$RssiValues.text += '\n'
		$TimestampValues.text += str(timestamp)
		$TimestampValues.text += '\n'
