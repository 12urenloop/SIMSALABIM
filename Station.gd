extends Node2D

@export var port: int
@onready var _ws_server: WebSocketServer

var detections = []
var last_id: int = 0

var enabled: bool = true
var hover: bool = false

# Signaal sterkte van -60 (sterk) -> -100 (heeel zwak) (logaritmisch)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UI/Name.text = name
	_ws_server = WebSocketServer.new()
	var err = _ws_server.listen(port-1000)
	if err != OK:
		print("Error listing on port %s" % (port-1000))
		return
	_ws_server.connect("message_received", _on_web_socket_server_message_received)
	_ws_server.connect("client_connected", _on_web_socket_server_client_connected)
	_ws_server.connect("client_disconnected", _on_web_socket_server_client_disconnected)

func _draw() -> void:
	# draw_set_transform(Vector2(18,64),0,Vector2(2,3))
	var color = Color(.0, .6, .0, .2) if enabled else Color(.6, .0, .0, .2)
	draw_circle(Vector2(0,0),20.0,color)

func add_detection(baton: PathFollow2D):
	if not enabled:
		return
		
	var timestamp := Time.get_unix_time_from_system()
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
	if _ws_server.tcp_server.is_listening():
		websocket_response(last_id-1, 0)


func _on_web_socket_server_client_connected(peer_id):
	var peer: WebSocketPeer = _ws_server.peers[peer_id]
	print("Remote client connected: %d. Protocol: %s" % [peer_id, peer.get_selected_protocol()])

func _on_web_socket_server_client_disconnected(peer_id):
	var peer: WebSocketPeer = _ws_server.peers[peer_id]
	print("Remote client disconnected: %d. Code: %d, Reason: %s" % [peer_id, peer.get_close_code(), peer.get_close_reason()])

func _on_web_socket_server_message_received(peer_id, message):
	print("Server received data from peer %d: %s" % [peer_id, message])
	var parsed_message = JSON.parse_string(message)
	if parsed_message == null:
		print("Received an invalid websocket message")
	websocket_response(parsed_message.lastId, peer_id)
	var lastId = parsed_message.lastId

func _process(delta):
	queue_redraw()
	
	_ws_server.poll()
	
	# TODO
	# Check if a baton is in the area of the station. Add a detection with a realistic rssi
	
	# Example detection from Ronny
	# {"detections":[{"id":1,"mac":"5a:45:55:53:00:0d","rssi":-93,"uptime_ms":11640403,"battery":91.0,"detection_timestamp":1648731113.262584},{"id":2,"mac":"5a:45:55:53:00:0d","rssi":-94,"uptime_ms":11640805,"battery":90.0,"detection_timestamp":1648731113.681251},{"id":3,"mac":"5a:45:55:53:00:0d","rssi":-90,"uptime_ms":11641107,"battery":91.0,"detection_timestamp":1648731113.999458},{"id":4,"mac":"5a:45:55:53:00:0d","rssi":-92,"uptime_ms":11641409,"battery":91.0,"detection_timestamp":1648731114.311439},{"id":5,"mac":"5a:45:55:53:00:0d","rssi":-93,"uptime_ms":11641610,"battery":91.0,"detection_timestamp":1648731114.517304},{"id":6,"mac":"5a:45:55:53:00:0d","rssi":-93,"uptime_ms":11642917,"battery":91.0,"detection_timestamp":1648731115.780825},{"id":7,"mac":"5a:45:55:53:00:0d","rssi":-97,"uptime_ms":11644125,"battery":90.0,"detection_timestamp":1648731117.035905},{"id":8,"mac":"5a:45:55:53:00:0d","rssi":-92,"uptime_ms":11646539,"battery":91.0,"detection_timestamp":1648731119.440587},{"id":9,"mac":"5a:45:55:53:00:0b","rssi":-98,"uptime_ms":11407016,"battery":89.0,"detection_timestamp":1648731119.533558},{"id":10,"mac":"5a:45:55:53:00:0d","rssi":-92,"uptime_ms":11646941,"battery":91.0,"detection_timestamp":1648731119.861905}],"station_id":"xps9300"}
	
	$UI/DetectionCount.text = str(detections.size())

func response(index):
	return JSON.stringify({
		"station_id": self.name,
		"detections": detections.slice(index, detections.size())
	})

func websocket_response(index, peer_id: int):
	if detections.size() - index < 20:
		var msg = JSON.stringify(detections.slice(index, detections.size()))
		_ws_server.send(peer_id, msg)
		return
	
	for size in range(index, detections.size()-20, 20):
		var msg = JSON.stringify(detections.slice(size, size+20))
		_ws_server.send(peer_id, msg)

func _on_CheckButton_toggled(button_pressed: bool) -> void:
	enabled = button_pressed
