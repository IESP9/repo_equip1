extends CharacterBody2D

const SPEED = 200.0
const ACCELERATION = 600.0  # Acelera y desacelera suavemente
const FRICTION = 600.0      # para reducir la velocidad poco a poco

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	move_and_slide()
