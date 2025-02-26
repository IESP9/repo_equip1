extends CharacterBody2D  # Script de la bala

@export var speed: float = 300      # Velocidad de la bala
var direction: Vector2 = Vector2.UP  # Dirección de disparo (arriba)
var is_shooting: bool = false        # Indica si la bala está en movimiento

func _physics_process(delta: float) -> void:
	if is_shooting:
		var collision = move_and_collide(direction * speed * delta)
		if collision:
			# Se ha colisionado, se destruye la bala
			queue_free()

func shoot(start_position: Vector2, color: String) -> void:
	# Establece la posición y activa el movimiento
	position = start_position
	is_shooting = true
	
	# Cambia el color del sprite si existe
	var sprite = $AnimatedSprite2D
	if sprite:
		match color:
			"red": sprite.modulate = Color.RED
			"blue": sprite.modulate = Color.BLUE
			"green": sprite.modulate = Color.GREEN
	
	# Inicia un temporizador para autodestruir la bala después de 2 segundos
	get_tree().create_timer(2.0).connect("timeout", Callable(self, "_on_timer_timeout"))

func _on_timer_timeout() -> void:
	# Se autodestruye la bala
	queue_free()
