tool
extends Node2D

# 1024, 600

var center = Vector2(500,300)
var width = 40
var height = 20

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _draw():
	draw_set_transform(center, 0, Vector2(5,3))
	draw_circle(Vector2(0,0), 60.0, Color(0.0,0.0,0.0,0.2))
	
	draw_set_transform(center, 0, Vector2(6,4))
	draw_circle(Vector2(0,0), 60.0, Color(0.0,0.0,0.0,0.1))


func _process(delta):
	update()
