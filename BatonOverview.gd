extends GridContainer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var batons = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for baton in get_tree().get_nodes_in_group("baton_root"):
		batons.append(baton)

	for baton in self.batons:
		print("Add baton to grid")
		var label = Label.new()
		label.text = baton.name
		add_child(label)
		var label_mac = Label.new()
		label_mac.text = baton.mac
		add_child(label_mac)
		var label_laps = Label.new()
		label.text = str(baton.laps)
		add_child(label_laps)
		baton.connect("laps_changed", self, "_on_baton_laps_changed", [baton, label_laps])

func _on_baton_laps_changed(laps, baton, label_laps):
	label_laps.text = str(laps)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
