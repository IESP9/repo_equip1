extends Node2D  # Nodo que maneja las balas

# Referencias a las balas en la escena
@onready var bala_list = [$Bala7, $Bala8, $Bala9, $Bala10, $Bala11, $Bala12]
var current_bullet: int = 0  # Índice de la bala a disparar

@onready var timer: Timer = $Timer

func _ready():
	# Configurar el Timer
	timer.wait_time = 5.0  # Cada 5 segundos dispara automáticamente
	timer.one_shot = false
	timer.autostart = true

	# Conectar la señal timeout del Timer solo si no está ya conectada
	if not timer.is_connected("timeout", Callable(self, "_on_timer_timeout")):
		timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func _process(_delta):  # Prefijo con _ para evitar advertencia
	# Detecta si el jugador presiona la tecla ESPACIO para disparar
	if Input.is_action_just_pressed("shoot"):
		disparar()

func _on_timer_timeout() -> void:
	disparar()  # Llama a la función de disparo cuando el Timer se activa

func disparar():
	if bala_list.is_empty():
		return  # Si no hay balas, no hacer nada

	var bullet = bala_list[current_bullet]

	# Asegurar que la bala no está disparando antes de reutilizarla
	if bullet.is_shooting:
		return  

	# Dispara la bala desde el centro del nodo (posiblemente un personaje)
	bullet.shoot(global_position, "red")  # Puedes cambiar el color
	
	# Actualiza el índice para la siguiente bala
	current_bullet = (current_bullet + 1) % bala_list.size()
