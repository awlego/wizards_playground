extends Area2D

var is_current_snap_choice = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	self.area_shape_entered.connect(_on_area_shape_entered)
	self.area_shape_exited.connect(_on_area_shape_exited)
	
	modulate = Color(Color.MEDIUM_PURPLE, 0.7)
	$HighlightColorRect.visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Global.is_dragging:
		visible = true
	else:
		visible = true
		
func set_current_snap_choice(is_chosen):
	is_current_snap_choice = is_chosen
	if is_current_snap_choice:
		$HighlightColorRect.visible = true
		Global.snap_location = global_position
	else:
		$HighlightColorRect.visible = false
	

func _on_mouse_entered():
	#print(global_position)
	Global.snap_location = global_position

func _on_mouse_exited():
	#print("resetting snap location")
	Global.snap_location = null

signal custom_on_area_shape_entered
func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var caller_id = get_path()
	custom_on_area_shape_entered.emit(area_rid, area, area_shape_index, local_shape_index, caller_id)

signal custom_on_area_shape_exited
func _on_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	var caller_id = get_path()
	custom_on_area_shape_exited.emit(area_rid, area, area_shape_index, local_shape_index, caller_id)

