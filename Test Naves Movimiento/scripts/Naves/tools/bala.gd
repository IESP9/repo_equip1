extends Area2D

@export var direction: BulletDirection # Asigna la dirección desde el inspector
@export var velocidad: int = 500  # Velocidad de la bala (ajustable desde el inspector)
@export var grupos_enemigos: Array[String] = ["enemigos_aliens", "enemigos_humanos"]  # Grupos de enemigos

enum BulletDirection {
	TOP,    # Hacia arriba
	BOTTOM  # Hacia abajo
}

func _ready():
	# Rotar la bala según la dirección (opcional, si tiene un sprite)
	match direction:
		BulletDirection.BOTTOM:
			rotation_degrees = 90  # Apuntar hacia abajo
		BulletDirection.TOP:
			rotation_degrees = -90    # Apuntar hacia arriba

func _physics_process(delta):
	# Movimiento de la bala
	match direction:
		BulletDirection.BOTTOM:
			global_position.y += velocidad * delta # Movimiento hacia abajo
		BulletDirection.TOP:
			global_position.y -= velocidad * delta # Movimiento hacia arriba

	# Verificar si la bala está fuera de los límites de la cámara
	if _esta_fuera_de_la_camara():
		queue_free()  # Destruir la bala si está fuera de la vista

func _on_body_entered(body):
	# Detectar colisiones con enemigos
	for grupo in grupos_enemigos:
		if body.is_in_group(grupo):
			body.take_damage(10)  # Aplicar daño al enemigo
			break  # Salir del bucle después de encontrar una coincidencia
	queue_free()  # Destruir la bala siempre

func _esta_fuera_de_la_camara() -> bool:
	# Obtener la cámara actual
	var camara = get_viewport().get_camera_2d()
	if not camara:
		return false  # Si no hay cámara, no hacer nada

	# Obtener el rectángulo visible de la cámara
	var viewport_rect = camara.get_viewport_rect()
	var camara_pos = camara.global_position

	# Calcular los límites de la cámara
	var limite_izquierdo = camara_pos.x - viewport_rect.size.x / 2
	var limite_derecho = camara_pos.x + viewport_rect.size.x / 2
	var limite_superior = camara_pos.y - viewport_rect.size.y / 2
	var limite_inferior = camara_pos.y + viewport_rect.size.y / 2

	# Verificar si la bala está fuera de los límites
	return (
		global_position.x < limite_izquierdo or
		global_position.x > limite_derecho or
		global_position.y < limite_superior or
		global_position.y > limite_inferior
	)
