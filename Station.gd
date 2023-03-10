extends Node2D

export(int) var port

var detections = []
var last_id: int = 0

var enabled: bool = true
var hover: bool = false

# Signaal sterkte van -60 (sterk) -> -100 (heeel zwak) (logaritmisch)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UI/Name.text = name

func _draw() -> void:
	# draw_set_transform(Vector2(18,64),0,Vector2(2,3))
	var color = Color(.0, .6, .0, .2) if enabled else Color(.6, .0, .0, .2)
	draw_circle(Vector2(0,0),20.0,color)

func add_detection(baton: PathFollow2D):
	if not enabled:
		return
		
	var timestamp := float(OS.get_system_time_msecs()) / 1000
	var distance := self.global_position.distance_to(baton.global_position)
	var max_dist: float = $Area2D/CollisionShape2D.get_shape().radius
	var dist_perc = distance/max_dist
	var min_rssi = -100
	var max_rssi = -50
	var rssi_value_width = min_rssi - max_rssi
	
	var new_rssi = (dist_perc * rssi_value_width) + max_rssi
	
	detections.append({
		"id": last_id, "mac": baton.mac,
		"rssi": new_rssi, "uptime_ms": 0, "battery": 0.0, 
		"detection_timestamp": timestamp
	})
	last_id += 1
	
	# $DetectionGraph.add_point(timestamp, new_rssi*-1)
	baton.emit_signal("detection_registered", self, new_rssi, timestamp)

func _process(delta):
	update()
	
	# TODO
	# Check if a baton is in the area of the station. Add a detection with a realistic rssi
	
	# Example detection from Ronny
	# {"detections":[{"id":1,"mac":"5a:45:55:53:00:0d","rssi":-93,"uptime_ms":11640403,"battery":91.0,"detection_timestamp":1648731113.262584},{"id":2,"mac":"5a:45:55:53:00:0d","rssi":-94,"uptime_ms":11640805,"battery":90.0,"detection_timestamp":1648731113.681251},{"id":3,"mac":"5a:45:55:53:00:0d","rssi":-90,"uptime_ms":11641107,"battery":91.0,"detection_timestamp":1648731113.999458},{"id":4,"mac":"5a:45:55:53:00:0d","rssi":-92,"uptime_ms":11641409,"battery":91.0,"detection_timestamp":1648731114.311439},{"id":5,"mac":"5a:45:55:53:00:0d","rssi":-93,"uptime_ms":11641610,"battery":91.0,"detection_timestamp":1648731114.517304},{"id":6,"mac":"5a:45:55:53:00:0d","rssi":-93,"uptime_ms":11642917,"battery":91.0,"detection_timestamp":1648731115.780825},{"id":7,"mac":"5a:45:55:53:00:0d","rssi":-97,"uptime_ms":11644125,"battery":90.0,"detection_timestamp":1648731117.035905},{"id":8,"mac":"5a:45:55:53:00:0d","rssi":-92,"uptime_ms":11646539,"battery":91.0,"detection_timestamp":1648731119.440587},{"id":9,"mac":"5a:45:55:53:00:0b","rssi":-98,"uptime_ms":11407016,"battery":89.0,"detection_timestamp":1648731119.533558},{"id":10,"mac":"5a:45:55:53:00:0d","rssi":-92,"uptime_ms":11646941,"battery":91.0,"detection_timestamp":1648731119.861905}],"station_id":"xps9300"}
	
	$UI/DetectionCount.text = str(detections.size())

func response(index):
	return JSON.print({
		"station_id": self.name,
		"detections": detections.slice(index, detections.size())
	})


func _on_CheckButton_toggled(button_pressed: bool) -> void:
	enabled = button_pressed
