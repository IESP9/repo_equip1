extends CharacterBody2D

@export var speed: float = 40               # Velocidad de movimiento del enemigo
@export var shoot_interval: float = 5.0       # Intervalo entre disparos (5 segundos)
@export var lateral_amplitude: float = 10.0   # Amplitud del movimiento lateral (oscilación)
# direcion de la bala

@onready var player: CharacterBody2D = $"../Amazon1"  # Referencia al protagonista (Amazon1)
@onready var timer: Timer = $Timer  # Timer para disparos 
@onready var bala: Area2D = $Bala  # Escena de la bala 


var time_accumulator: float = 0.0  # Acumula el tiempo para la oscilación lateral

func _ready():
	# Configurar el Timer de disparo
	timer.wait_time = shoot_interval
	timer.one_shot = false
	timer.autostart = true
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))

func _physics_process(delta):
	# Actualizar el acumulador de tiempo
	time_accumulator += delta
	# Calcular un offset lateral usando una función senoidal para lograr una oscilación
	var lateral_offset = sin(time_accumulator * 2) * lateral_amplitude
	
	if player:
		# La posición objetivo es la posición X del jugador más el offset lateral
		var target_x = player.global_position.x + lateral_offset
		# Mover suavemente la posición X del enemigo hacia la posición objetivo
		global_position.x = lerp(global_position.x, target_x, 0.05)
		
		# Opcional: podrías ajustar la posición Y si deseas cierto seguimiento vertical
		# global_position.y = lerp(global_position.y, player.global_position.y, 0.02)

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
		get_tree().current_scene.add_child(nueva_bala)
		# Colocar la bala en la posición actual del enemigo
		nueva_bala.global_position = global_position
		
		# Disparar hacia abajo
		var direction = Vector2.DOWN  # La bala se moverá hacia abajo
		
		# Llamar al método shoot de la bala. Se asume que el método acepta: posición, color y dirección
		nueva_bala.shoot(global_position, "red", direction)
	else:
		print("No se ha asignado la escena de la bala.")
