extends Node2D

# Vida y barra de vida
var vida: int = 100
@onready var barradevida: ProgressBar = $barradevida

# Prefab de la bala y Timer
var bala_prefab = preload("res://Escenas/ESCENAS NODOS/naves/tools/bala.tscn")
@onready var timer: Timer = $Timer

# Movimiento horizontal
var velocidad_movimiento: int = 100  # Velocidad de movimiento horizontal
var direccion_movimiento: int = 1    # Dirección del movimiento (1: derecha, -1: izquierda)

# Movimiento de desvío
var velocidad_desvio: int = 200  # Velocidad para esquivar
var direccion_desvio: int = 1    # Dirección del desvío (1: derecha, -1: izquierda)

func take_damage(damage: int):
	vida -= damage
	barradevida.value = vida
	if vida <= 0:
		queue_free()

func _on_timer_timeout():
	# Instanciar una bala
	var nueva_bala = bala_prefab.instantiate()
	
	# Configurar la posición y dirección de la bala
	nueva_bala.global_position = global_position
	nueva_bala.direction = nueva_bala.BulletDirection.BOTTOM  # Disparar hacia abajo
	
	# Añadir la bala a la escena
	get_parent().add_child(nueva_bala)

func _on_area_detectar_balas_entered(area):
	# Detectar si la bala del jugador entra en contacto
	if area.is_in_group("balas_jugador"):
		# Intentar desviarse
		desviar()
		# Eliminar la bala del jugador (opcional, si no quieres que se destruya al detectarla)
		# area.queue_free()

func _on_area_recibir_dano_entered(area):
	# Detectar si la bala del jugador entra en contacto
	if area.is_in_group("balas_jugador"):
		# Aplicar daño
		take_damage(10)
		# Eliminar la bala del jugador
		area.queue_free()

func desviar():
	# Mover al alien lateralmente para esquivar
	position.x += velocidad_desvio * direccion_desvio * get_process_delta_time()
	
	# Cambiar la dirección del desvío para el próximo movimiento
	direccion_desvio *= -1

func _physics_process(delta):
	# Movimiento horizontal continuo
	position.x += velocidad_movimiento * direccion_movimiento * delta
	
	# Verificar los límites de la cámara
	_verificar_limites_camara()

func _verificar_limites_camara():
	# Obtener la cámara actual
	var camara = get_viewport().get_camera_2d()
	if not camara:
		return  # Si no hay cámara, no hacer nada

	# Obtener el rectángulo visible de la cámara
	var viewport_rect = camara.get_viewport_rect()
	var camara_pos = camara.global_position

	# Calcular los límites de la cámara
	var limite_izquierdo = camara_pos.x - viewport_rect.size.x / 2
	var limite_derecho = camara_pos.x + viewport_rect.size.x / 2

	# Ajustar la posición del alien para que no salga de los límites de la cámara
	position.x = clamp(position.x, limite_izquierdo, limite_derecho)

	# Cambiar dirección si alcanza los límites
	if position.x <= limite_izquierdo:
		direccion_movimiento = 1  # Mover hacia la derecha
	elif position.x >= limite_derecho:
		direccion_movimiento = -1  # Mover hacia la izquierda
