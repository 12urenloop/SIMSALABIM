tool
extends PathFollow2D

# handjes
# bewegingslijnen
# voetstappen

export(String) var mac  = "00:00:00:00:00:01"

var rng = RandomNumberGenerator.new()

var laps: int = 0

var color: Color
var speed: float
var speed_offset: float = 0.0
var temp_slow: float = 1.0 # speed modifier that will always try to lerp back to 1
var speed_consistency: float = 1.0
var stop_chance: float = 0.0
var home_base: float = 0.0

# Frequency is 8 per second
var delta_since_last_emission: float = 0.0

func get_track_distance():
	return get_parent().get_curve().get_baked_length()
func get_progress():
	return offset/get_track_distance()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	offset = 0
	stop_chance = rng.randf_range(0.0, 1.0)
	home_base = rng.randf_range(0.0, 1.0) * get_track_distance()
	speed = rng.randf_range(2.0, 3.0) # .4, 1.0
	
	color = Color(rng.randf_range(.4, .8), rng.randf_range(.4, .8), rng.randf_range(.4, .8), 0.8)

	# mac = ("00-B0-D0-63-C2-%s%s" % [rng.randi_range(0, 10), rng.randi_range(0, 10)])
	$Mac.text = mac

func _draw():
	draw_circle(Vector2(0,0),20.0,color)


func _process(delta):
	delta_since_last_emission += delta
	if delta_since_last_emission > 1.0/8.0:
		delta_since_last_emission -= 1.0/8.0
		
		for area in $Area2D.get_overlapping_areas():
			if area.is_in_group("station"):
				var station = area.get_parent()
				station.add_detection(self)
	
	update()
	var previous_offset = offset
	
	temp_slow = lerp(temp_slow, 1.0, .1)
	
	offset += ((speed + speed_offset) * temp_slow)
	if offset < previous_offset:
		laps += 1
		
		speed_offset += rng.randf_range(-.05, .05)
		speed_offset = clamp(speed_offset, -.2, .2)
	
	if previous_offset < home_base and offset > home_base:
		temp_slow = .3
	
		
	$Progress.text = str(round(get_progress()*100)/100)
	$Laps.text = "Laps: " + str(laps)
	$Speed.text = str(temp_slow * speed)
