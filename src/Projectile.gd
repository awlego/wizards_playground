extends Area2D

@export var speed: float = 400.0
@export var direction: Vector2 = Vector2.ZERO

signal hit(target: Node)

func _ready():
	self.body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	emit_signal("hit", body)
	queue_free()
