extends Node2D

@onready var bolt_scene = preload("res://src/Bolt.tscn")
@onready var spell_slots = 

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func cast() -> void:
	shoot_purple_bolt()
	
func shoot_bolt(frames_path: String) -> void:
	if frames_path == "":
		print("Error: No frames path provided for bolt.")
		return

	var bolt = bolt_scene.instantiate()
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - self.global_position).normalized()
	
	bolt.direction = direction
	bolt.rotation = direction.angle()
	bolt.frames_path = frames_path # Set the frames of the bolt
	bolt.position = self.global_position # Set the starting position to the wand's center

	self.get_parent().get_parent().add_child(bolt)


func shoot_purple_bolt() -> void:
	shoot_bolt("res://assets/frames/purple_bolt_frames.tres")

func shoot_blue_bolt() -> void:
	shoot_bolt("res://assets/frames/blue_bolt_frames.tres")
