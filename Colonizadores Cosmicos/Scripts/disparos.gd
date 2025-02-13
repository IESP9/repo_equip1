extends Node2D  # Nodo que maneja las balas

# Referencias a las balas en la escena
@onready var bala_list = [$Bala7, $Bala8, $Bala9, $Bala10, $Bala11, $Bala12]
var current_bullet: int = 0  # Índice de la bala a disparar

func _ready():
	# Configurar el Timer

	var timer = Timer.new($"../../Timer")
	timer.wait_time = 5.0  # Cada 5 segundos dispara automáticamente
	timer.one_shot = false
	timer.autostart = true
	add_child(timer)

	# Conectar la señal timeout del Timer
	timer.timeout.connect(_on_Timer_timeout)

func _process(delta):
	# Detecta si el jugador presiona la tecla ESPACIO para disparar
	if Input.is_action_just_pressed("shoot"):
		disparar()

func _on_Timer_timeout():
	disparar()  # Llama a la función de disparo cuando el Timer se activa

func disparar():
	if bala_list.is_empty():
		return  # Si no hay balas, no hacer nada

	var bullet = bala_list[current_bullet]

	# Asegurar que la bala no está disparando antes de reutilizarla
	if bullet.is_shooting:
		return  

	# Dispara la bala desde la posición del nodo padre (posiblemente un personaje)
	bullet.shoot(global_position, "red")  # Puedes cambiar el color
	
	# Actualiza el índice para la siguiente bala
	current_bullet = (current_bullet + 1) % bala_list.size()


func _on_timer_timeout() -> void:
	 pass # Replace with function body.
