extends Area2D

var speed = 600  # Movement speed in pixels per second
var damage = 10
var enemy

func _ready():
	var parent_node = get_parent()
	for child in parent_node.get_children():
		if child.name == "Enemy":
			enemy = child
	$Sprite2D.play("default")
	self.connect("area_entered", Callable(self, "_on_entity_area_entered"))
	#_debug_draw_targeting_line()
	
func _process(delta):
	var direction
	if not enemy:
		direction = global_position.normalized()
	else:
		direction = (enemy.global_position - global_position).normalized()
	global_position += direction * speed * delta

func _debug_draw_targeting_line():
	var parent_node = get_parent()
	for child in parent_node.get_children():
		if child.name == "Enemy":
			enemy = child
	if not enemy:
		return

	var line = Line2D.new()
	
	line.add_point(Vector2(global_position.normalized()))
	line.add_point(Vector2(enemy.global_position.normalized()))
	print("drawing targeting line", global_position.normalized(), enemy.global_position.normalized())
	line.default_color = Color(1, 1, 1)
	
	line.width = 3.0
	
	self.add_child(line)
	

func _on_entity_area_entered(area):
	if area.name == "Enemy":
		queue_free()
