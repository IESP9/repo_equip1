extends CharacterBody2D

# Velocidad de movimiento y disparo
@export var speed: float = 40  # Velocidad de movimiento
@export var shoot_interval: float = 5.0  # Intervalo entre disparos (5 segundos)
const UPWARD_SPEED = -10.0  # Velocidad constante hacia arriba (en 2D, Y positivo es hacia abajo)

var escudos: int = 100
@onready var escudosbar: ProgressBar = $escudosenemigo

@onready var point_shoot: Marker2D = $PointShoot

# Límites de movimiento
@export var left_limit: float = 220  # Límite izquierdo
@export var right_limit: float = 220  # Límite derecho

# Referencia al nodo Timer (asegúrate de que exista en la escena)
@onready var timer: Timer = $Timer
# Referencia al héroe (debe existir en la escena)
@onready var Herore: CharacterBody2D = $"../Amazon1"

# Precarga de la escena de bala (cambia la ruta según corresponda)
const bullet_scene = preload("res://Escenas/ESCENAS NODOS/bala.tscn")

# Estado de dirección
var moving_right: bool = true
var moving_left: bool = false

func actualizar_hud():
	escudosbar.value = escudos

func take_damage(amount: int) -> void:
	escudos = max(escudos - amount, 0)
	actualizar_hud()
	
	if escudos <= 0:
		queue_free()

func _ready():
	actualizar_hud()
	
	# Configura el temporizador para disparar cada "shoot_interval" segundos
	timer.wait_time = shoot_interval
	timer.one_shot = false
	timer.autostart = true

	# Conecta la señal "timeout" usando la nueva sintaxis
	timer.timeout.connect(_on_Timer_timeout)

# Este método se llama cuando el temporizador se activa
func _on_Timer_timeout():
	disparar_bala()

# Función para disparar la bala
func disparar_bala():
	# Instancia la bala y la posiciona en el marcador de disparo
	var bullet = bullet_scene.instantiate()
	bullet.global_position = point_shoot.global_position
	# Agrega la bala a la escena actual (o a otra que decidas)
	get_tree().current_scene.add_child(bullet)
	
	# Si el script de la bala tiene un método 'shoot', puedes llamarlo, por ejemplo:
	# bullet.shoot(point_shoot.global_position, "red")
	
	print("¡Disparo!")
