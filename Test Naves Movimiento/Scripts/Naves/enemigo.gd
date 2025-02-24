extends Area2D

@export var speed: float = 40 # Velocidad de movimiento del enemigo
@export var shoot_interval: float = 5.0 # Intervalo entre disparos (5 segundos)
@export var lateral_amplitude: float = 150.0 # Amplitud del movimiento lateral (oscilación)

@onready var amazon_1: Area2D = $Amazon1  # Referencia al jugador
@onready var timer: Timer = $Amazon1/alien/Timer2  # Timer para disparos
@onready var bala: PackedScene = preload("res://Escenas/ESCENAS NODOS/bala.tscn")  # Escena de la bala (ajusta la ruta)

var time_accumulator: float = 0.0  # Acumula el tiempo para la oscilación lateral

func _ready():
	# Configurar el Timer de disparo
	timer.wait_time = shoot_interval
	timer.one_shot = false
	timer.autostart = true
	timer.timeout.connect(_on_Timer_timeout)
	
	# Conectar señales de colisión
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	# Actualizar el acumulador de tiempo
	time_accumulator += delta
	
	# Calcular un offset lateral usando una función senoidal para lograr una oscilación
	var lateral_offset = sin(time_accumulator * 2) * lateral_amplitude
	
	if player:
		# La posición objetivo es la posición X del jugador más el offset lateral
		var target_x = player.global_position.x + lateral_offset
		
		# Mover suavemente la posición X del enemigo hacia la posición objetivo
		global_position.x = lerp(global_position.x, target_x, delta * speed)
		
		# Opcional: Ajustar la posición Y si deseas cierto seguimiento vertical
		# global_position.y = lerp(global_position.y, player.global_position.y, delta * speed * 0.5)

# Se ejecuta cada vez que el timer hace timeout (cada shoot_interval segundos)
func _on_Timer_timeout():
	disparar_bala()

# Función para disparar una bala
func disparar_bala():
	print("¡Disparo del enemigo!")
	if bala:
		# Instanciar la bala
		var nueva_bala = bala.instantiate()
		
		# Agregarla a la escena actual (asegúrate de que se coloque en el árbol de nodos correcto)
		get_parent().add_child(nueva_bala)
		
		# Colocar la bala en la posición actual del enemigo
		nueva_bala.global_position = global_position
		
		# Disparar hacia abajo
		var direction = Vector2.DOWN  # La bala se moverá hacia abajo
		
		# Llamar al método shoot de la bala
		if nueva_bala.has_method("shoot"):
			nueva_bala.shoot(global_position, "red", direction)
	else:
		print("Error: No hay escena de bala asignada")

# Detectar colisiones con el jugador
func _on_body_entered(body: Node):
	if body.is_in_group("enemigos de aliens"):
		body.take_damage(10)  # Restar vida al jugador

# Detectar colisiones con áreas (opcional)
#func _on_area_entered(area: Area2D):
	#if area.is_in_group("enemigos de aliens"):
		#area.queue_free()  # Eliminar la bala del jugador
		#queue_free()       # Destruir el enemigo
		#if player:
			#player.add_score(100)  # Sumar puntos al jugador
