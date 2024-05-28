extends Area2D

var speed = 150  # Movement speed in pixels per second
var current_health: int = 20
#@export var health: int = 100
var faction = 2
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
	self.connect("area_entered", Callable(self, "_on_area_entered"))
	position.x = 300
	position.y = 300
	
	add_to_group("enemies")
	
	
func _process(delta):
	var direction = (player.global_position - global_position).normalized()
	global_position += direction * speed * delta
	pass
	
func _on_area_entered(area: Node):
	print(area.name, " entered the enemy hit box")
	if area.name == "Fireball":
		take_damage(area.damage)
	if area.name == "Player":
		player.take_damage(1)
	
func take_damage(damage: int):
	print("Enemy taking damage: {damage}", damage)
	current_health -= damage
	if current_health < 0:
		current_health = 0
	print("Enemy health after taking damage: ", current_health)
	if current_health == 0:
		die()

func die() -> void:
	# Handle enemy death (e.g., play animation, remove from scene)
	queue_free()
