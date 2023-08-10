extends Area2D

var speed = 150  # Movement speed in pixels per second

var player

func _ready():
	var parent_node = get_parent()
	for child in parent_node.get_children():
		print(child.name)
		if child.name == "Player":
			player = child

	print(player)
	print(player.global_position)
	self.connect("area_entered", Callable(self, "_on_Player_area_entered"))
	position.x = 300
	position.y = 300
	
func _process(delta):
	var direction = (player.global_position - global_position).normalized()
	global_position += direction * speed * delta
	pass
#	# Move the enemy
#	position.x += speed * direction * delta
#
#	# Check screen edges and reverse direction
#	if position.x > get_viewport_rect().size.x - texture.get_width()/2:
#		direction = -1
#		position.x = get_viewport_rect().size.x - texture.get_width()/2
#	elif position.x < texture.get_width()/2:
#		direction = 1
#		position.x = texture.get_width()/2
