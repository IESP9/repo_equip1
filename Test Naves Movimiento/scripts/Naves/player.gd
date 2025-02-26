extends Area2D

# Prefab de la bala
var bala_prefab = preload("res://Escenas/ESCENAS NODOS/naves/tools/bala.tscn")

# Configuración del movimiento
var velocidad: int = 400  # Velocidad de movimiento
var direccion_movimiento: int = 1  # Dirección del movimiento (1: derecha, -1: izquierda)

@onready var animated_sprite: AnimatedSprite2D = $Amazon1  # Asegúrate de que el nodo se llame así
@onready var marker2d: Marker2D = $Marker2D  # Referencia al Marker2D para disparar balas

func _input(event):
	if event.is_action_pressed("shoot"):
		# Instanciar la bala
		var nueva_bala = bala_prefab.instantiate()
		
		# Configurar la posición de la bala
		nueva_bala.global_position = marker2d.global_position
		
		# Configurar la dirección de la bala (usando el enum BulletDirection)
		nueva_bala.direction = nueva_bala.BulletDirection.TOP  # O BOTTOM, según necesites
		
		# Añadir la bala a la escena
		get_parent().add_child(nueva_bala)

func _physics_process(delta):
	# Obtener entrada horizontal
	var direccion: float = Input.get_axis("ui_left", "ui_right")
	
	# Mover al jugador
	position.x += direccion * velocidad * delta
	
	# Verificar los límites de la cámara
	_verificar_limites_camara()
	
	# Reproducir animación según la dirección
	if direccion != 0:
		animated_sprite.play("mover")  # Nombre de tu animación
		animated_sprite.flip_h = direccion < 0  # Voltear sprite si va a la izquierda
	else:
		animated_sprite.play("idle")  # Animación cuando está quieto

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

	# Ajustar la posición del jugador para que no salga de los límites de la cámara
	position.x = clamp(position.x, limite_izquierdo, limite_derecho)
