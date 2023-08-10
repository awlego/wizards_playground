extends Area2D

var speed = 300  # Movement speed in pixels per second
var damage = 10
var enemy

func _ready():
	var parent_node = get_parent()
	for child in parent_node.get_children():
		if child.name == "Enemy":
			enemy = child
	$Sprite2D.play("default")
	self.connect("area_entered", Callable(self, "_on_entity_area_entered"))
	
func _process(delta):
	var direction
	if not enemy:
		direction = global_position.normalized()
	else:
		direction = (enemy.global_position - global_position).normalized()
	global_position += direction * speed * delta

func _on_entity_area_entered(area):
	if area.name == "Enemy":
		queue_free()
