extends Area2D

var speed = 150  # Movement speed in pixels per second
var current_health = 20

var player

		
func _ready():
	current_health = 20
	var parent_node = get_parent()
	for child in parent_node.get_children():
		print(child.name)
		if child.name == "Player":
			player = child

	print(player)
	print(player.global_position)
	self.connect("area_entered", Callable(self, "_on_entity_area_entered"))
	position.x = 300
	position.y = 300
	
func _process(delta):
	var direction = (player.global_position - global_position).normalized()
	global_position += direction * speed * delta
	pass
	
func _on_entity_area_entered(area):
	print(area, "entered the enemy hit box")
	if area.name == "Fireball":
		take_damage(area.damage)
	
func take_damage(amount):
	print("Enemy taking damage: {amount}", amount)
	current_health -= amount
	if current_health < 0:
		current_health = 0
	print(current_health)
	if current_health == 0:
		queue_free() # mark this enemy for deletion

