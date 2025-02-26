extends Node2D  # Nodo que maneja las balas

# Referencias a las balas en la escena
@onready var bala_list = [$Bala7, $Bala8, $Bala9, $Bala10, $Bala11, $Bala12]
var current_bullet: int = 0  # Índice de la bala a disparar

#lista que guarda las balas que se recargaran despues
@onready var reload_list = []

@onready var reload_timer: Timer = $reload_timer2  # Iniciar como null para evitar errores


func _ready():
	# Intentar obtener el Timer
	if has_node("ReloadTimer"):
		reload_timer = $ReloadTimer
	else:
		print("⚠ Error: No se encontró ReloadTimer en la escena.")
		return  # No continuar si el Timer no existe

	# Configurar el Timer de recarga
	reload_timer.wait_time = 5.0  # Espera 5 segundos sin disparar para recargar
	reload_timer.one_shot = true  # Solo se activa una vez tras 5 segundos sin disparar
	reload_timer.connect("timeout", Callable(self, "_on_reload_timeout"))

func _process(_delta):  
	# Detecta si el jugador presiona la tecla ESPACIO para disparar
	if Input.is_action_just_pressed("shoot"):
		disparar()
		print("bam")
		if reload_timer:
			reload_timer.start()  # Reinicia el timer cada vez que se dispara

func disparar():
	# Si ya no hay balas disponibles, no dispares
	if current_bullet >= bala_list.size():
		return  

	var bullet = bala_list[current_bullet]

	# Asegurar que la bala no está disparando antes de reutilizarla
	if bullet.is_shooting:
		return  

	# Dispara la bala desde el centro del nodo
	bullet.shoot(global_position, "blue")  

	# Avanza al siguiente índice
	current_bullet += 1  

	# Si ya no hay balas, empieza a contar para la recarga
	if current_bullet >= bala_list.size() and reload_timer:
		reload_timer.start()

func _on_reload_timeout():
	# Recargar todas las balas después de 5 segundos sin disparos
	current_bullet = 0

	# Resetear cada bala para que pueda dispararse de nuevo
	for bullet in bala_list:
		if bullet.has_method("reset"):  # Si la bala tiene un método reset, llámalo
			bullet.reset()
		else:
			bullet.is_shooting = false  # Alternativa si no hay método reset
			bullet.visible = true  # Asegurar que vuelva a aparecer

	print("🔄 Balas recargadas!")


func _on_reload_timer_timeout() -> void:
	pass # Replace with function body.
