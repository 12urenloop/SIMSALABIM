extends Control

onready var chart: Chart = $VBoxContainer/Chart

# This Chart will plot 3 different functions
var fn_detections: Function
# var f2: Function

func _ready():
	# Let's create our @x values
	var x: Array = ArrayOperations.multiply_float(range(-10, 11, 1), 0.5)
	
	# And our y values. It can be an n-size array of arrays.
	# NOTE: `x.size() == y.size()` or `x.size() == y[n].size()`
	var y: Array = range(-50, -110, 10)
	# var y2: Array = ArrayOperations.add_float(ArrayOperations.multiply_int(ArrayOperations.sin(x), 20), 20)
	
	# Let's customize the chart properties, which specify how the chart
	# should look, plus some additional elements like labels, the scale, etc...
	var cp: ChartProperties = ChartProperties.new()
	# cp.colors.frame = Color("#161a1d")
	cp.colors.frame = Color.transparent
	cp.colors.background = Color.transparent
	cp.colors.grid = Color("#283442")
	cp.colors.ticks = Color("#283442")
	cp.colors.text = Color.whitesmoke
	cp.draw_bounding_box = false
	# cp.title = "Air Quality Monitoring"
	# cp.x_label = "Time"
	# p.y_label = "Sensor values"
	cp.x_scale = 5
	cp.y_scale = 10
	cp.interactive = true # false by default, it allows the chart to create a tooltip to show point values
	# and interecept clicks on the plot
	
	# Let's add values to our functions
	fn_detections = Function.new(
		x, y, "Detections" # This will create a function with x and y values taken by the Arrays 
						  # we have created previously. This function will also be named "Pressure"
						  # as it contains 'pressure' values.
						  # If set, the name of a function will be used both in the Legend
						  # (if enabled thourgh ChartProperties) and on the Tooltip (if enabled).
	)
	# f2 = Function.new(x, y2, "Humidity", { color = Color("#ff6384"), marker = Function.Marker.CROSS })
	
	# Now let's plot our data
	chart.plot([fn_detections], cp)
	
	# Uncommenting this line will show how real time data plotting works
	set_process(false)


var new_val: float = 4.5

func add_point(x, y):
	fn_detections.add_point(x, y)
	chart.update()

func _process(delta: float):
	# This function updates the values of a function and then updates the plot
	# new_val += 5
	
	# we can use the `Function.add_point(x, y)` method to update a function
	# f1.add_point(new_val, cos(new_val) * 20)
	# f2.add_point(new_val, (sin(new_val) * 20) + 20)
	# chart.update() # This will force the Chart to be updated
	pass


# func _on_CheckButton_pressed():
# 	set_process(not is_processing())
