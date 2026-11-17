extends CharacterBody2D

@export var speed: float = 600.0

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	var direction := Input.get_vector('move_left', 'move_right', 'move_up', 'move_down')
	velocity = direction * speed
	move_and_slide()
	
	var screen := get_viewport_rect().size
	position = position.clamp(Vector2.ZERO, screen)
