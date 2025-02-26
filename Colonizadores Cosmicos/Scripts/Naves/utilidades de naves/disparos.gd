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
