extends Area2D

signal hit_player

var speed: float = 300.0

func _ready() -> void:
	speed = randf_range(200.0, 550.0)
	add_to_group('enemies')
	
func _process(delta: float) -> void:
	position.y += speed * delta
	if position.y > get_viewport_rect().size.y + 60:
		queue_free()
			
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		hit_player.emit()
