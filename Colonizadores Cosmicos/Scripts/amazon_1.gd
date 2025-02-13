extends CharacterBody2D

@onready var hud: Control = %HUD

const SPEED_X = 200.0       # Velocidad lateral máxima
const ACCELERATION = 50.0  # Aceleración para el movimiento lateral
const FRICTION = 25.0      # Desaceleración (fricción) lateral cuando no se presiona ninguna tecla
const UPWARD_SPEED = -10.0 # Velocidad constante hacia arriba (en 2D, Y positivo es hacia abajo)
const FUEL_CONSUMPTION_RATE = 0.01  # Consumo de combustible por segundo

var fuel_timer: float = 0.0

func _physics_process(delta: float) -> void:
	var direction_x = Input.get_axis("ui_left", "ui_right")
	
	# Movimiento vertical constante
	velocity.y = UPWARD_SPEED
	
	# Movimiento lateral
	if direction_x != 0:
		velocity.x = move_toward(velocity.x, direction_x * SPEED_X, ACCELERATION * delta)
		
		# Consumir combustible al moverse
		if hud:
			fuel_timer += delta
			if fuel_timer >= 1.0:  # Reduce combustible continuamente
				hud.use_fuel(FUEL_CONSUMPTION_RATE)
				fuel_timer = 0.0
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	
	move_and_slide()

func _on_body_entered(body):
	if body.is_in_group("enemigos"):  # Asegurar de que los enemigos estén en un grupo llamado "enemigos"
		if hud:
			hud.take_damage(10)  # Resta 10 de vida al chocar con un enemigo

func destruir_enemigo():
	if hud:
		hud.add_score(100)  # Suma 100 puntos por cada enemigo destruido

func _process(_delta):
	if hud.combustible_val <= 0:
		velocity = Vector2.ZERO  # Detener la nave si no hay combustible
		hud.take_damage(100)
