extends ProgressBar

var screen_size = DisplayServer.window_get_size()
var screen_width = screen_size.x
var screen_height = screen_size.y


# Called when the node enters the scene tree for the first time.
func _ready():
	self.size.x = screen_width
	self.size.y = 100
	
	self.position.x = 0
	self.position.y = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
