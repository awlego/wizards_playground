extends Node

class_name Spell

@export var spell_stats: SpellStats

func _ready():
	if spell_stats:
		print("Damage: ", spell_stats.damage)
		print("Cast Delay: ", spell_stats.cast_delay)
		print("Recharge Time: ", spell_stats.recharge_time)
		print("Speed: ", spell_stats.speed)
		print("Lifetime Frames: ", spell_stats.lifetime_frames)
		$Sprite2D.texture = spell_stats.texture
