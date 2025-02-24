extends Area2D

@export var speed: float = 300  # Velocidad de la bala
var direction: Vector2 = Vector2.UP  # Dirección de disparo (arriba)
var is_shooting: bool = false  # Para saber si la bala está en movimiento
var original_position: Vector2  # Posición original de la bala

func _ready():
	# Guardar la posición original al inicio
	original_position = position

func _physics_process(delta):
	if is_shooting:
		# Mueve la bala manualmente
		position += direction * speed * delta

		# Verifica si la bala colisiona con algo
		for body in get_overlapping_bodies():
			if body.has_method("take_damage"):  # Si el objeto tiene una función take_damage()
				body.take_damage()
			reset()  # Resetea la bala

func shoot(start_position: Vector2, color: String):
	# Establece la posición inicial de la bala
	position = start_position
	is_shooting = true
	visible = true  # Hacer visible la bala al disparar

	# Cambia el color si tiene un Sprite2D
	var sprite = $AnimatedSprite2D
	if sprite:
		match color:
			"red": sprite.modulate = Color.RED
			"blue": sprite.modulate = Color.BLUE
			"green": sprite.modulate = Color.GREEN

	# Se "desactiva" después de 2 segundos en lugar de destruirse
	await get_tree().create_timer(2.0).timeout
	reset()

func reset():
	is_shooting = false
	visible = false  # Hacer invisible la bala en lugar de eliminarla
	position = original_position  # Restaurar la posición original
