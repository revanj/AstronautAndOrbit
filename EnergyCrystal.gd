extends Area2D
class_name EnergyCrystal

signal crystal_collected

@onready var sprite = $EnergyStarSprite

func _on_body_entered(body:Node2D):
	if body.is_in_group("spaceship"):
		emit_signal("crystal_collected")
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(sprite, "modulate", Color.TRANSPARENT, 1)
		tween.tween_property(sprite, "scale", Vector2(3,3), 1)
		tween.set_parallel(false)
		tween.tween_callback(self.queue_free)
