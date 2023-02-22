extends GridContainer

var selected_baton = 'Baton'

func _ready() -> void:
	for baton in get_tree().get_nodes_in_group("baton_root"):
		if baton.name == selected_baton:
			baton.connect("detection_registered", self, "_on_detection_registered")

func _on_detection_registered(station, rssi, timestamp):
	var label_baton = Label.new()
	label_baton.text = selected_baton
	add_child(label_baton)
	var label_station = Label.new()
	label_station.text = station.name
	add_child(label_station)
	var label = Label.new()
	label.text = str(rssi)
	add_child(label)
	var label2 = Label.new()
	label2.text = str(timestamp)
	add_child(label2)
