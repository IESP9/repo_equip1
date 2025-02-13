extends CharacterBody2D

# Velocidad de movimiento y disparo
@export var speed: float = 40  # Velocidad de movimiento
@export var shoot_interval: float = 5.0  # Intervalo entre disparos (5 segundos)
const UPWARD_SPEED = -10.0  # Velocidad constante hacia arriba (en 2D, Y positivo es hacia abajo)

# Limites de movimiento (pueden ser valores que se ajusten a tus necesidades)
@export var left_limit: float = 220  # Límite izquierdo
@export var right_limit: float = 380  # Límite derecho (ajustado para lógica correcta)

# Referencia al nodo Timer (debe existir en la escena)
@onready var timer: Timer = $"../Amazon1/disparos amazon/Timer"

# Estado de dirección (izquierda o derecha)
var moving_right: bool = true
var moving_left: bool = false  # Variable para la dirección hacia la izquierda

func _ready():
	# Configura el temporizador
	timer.wait_time = shoot_interval
	timer.one_shot = false
	timer.autostart = true

	# Conecta la señal "timeout" usando la nueva sintaxis:
	timer.timeout.connect(_on_Timer_timeout)

func _process(_delta):
	# Movimiento de lado a lado dentro de los límites establecidos
	if moving_right:
		position.x += speed * _delta  # Mueve a la derecha
		if position.x >= right_limit:  # Si llega al límite derecho
			moving_right = false
			moving_left = true  # Cambia la dirección a la izquierda
	elif moving_left:
		position.x -= speed * _delta  # Mueve a la izquierda
		if position.x <= left_limit:  # Si llega al límite izquierdo
			moving_left = false
			moving_right = true  # Cambia la dirección a la derecha

	# Movimiento vertical constante hacia arriba
	position.y += UPWARD_SPEED * _delta

# Este método se llama cuando el temporizador termina
func _on_Timer_timeout():
	disparar_bala()  # Llama a la función para disparar la bala

# Función para disparar la bala
func disparar_bala():
	print("¡Disparo!")
	# Aquí agregarías la lógica para instanciar o activar una bala
