extends CharacterBody2D

@export var speed: float = 300  # Velocidad de la bala
var direction: Vector2 = Vector2.UP  # Dirección de disparo (arriba)
var is_shooting: bool = false  # Para saber si la bala está en movimiento

func _physics_process(delta):
	if is_shooting:
		var collision = move_and_collide(direction * speed * delta)
		if collision:
			# Manejar la colisión, por ejemplo, destruir la bala
			queue_free()
			is_shooting = false  # Asegurarse de que la bala no siga moviéndose

func shoot(start_position: Vector2, color: String):
	# Establece la posición inicial de la bala
	position = start_position
	is_shooting = true
	
	# Cambia el color si tiene un Sprite2D
	var sprite = $AnimatedSprite2D  # Asegúrate de que la bala tiene un `Sprite2D`
	if sprite:
		match color:
			"red": sprite.modulate = Color.RED
			"blue": sprite.modulate = Color.BLUE
			"green": sprite.modulate = Color.GREEN

	# Se autodestruye después de 2 segundos
	await get_tree().create_timer(2.0).timeout
	queue_free()
	is_shooting = false  # Asegurarse de que la bala no siga moviéndose después de autodestruirse
