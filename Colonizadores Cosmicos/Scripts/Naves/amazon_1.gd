extends CharacterBody2D

@onready var hud: Control = %HUD
const bullet_scene = preload("res://Escenas/ESCENAS NODOS/bala.tscn")
@onready var pointshoot: Marker2D = $pointshoot

const SPEED_X = 200.0
const ACCELERATION = 2.0
const FRICTION = 25.0
const UPWARD_SPEED = -10.0
const FUEL_CONSUMPTION_RATE = 0.5  # Ajustado para mayor consumo
const MAX_AMMO = 6

var fuel_timer: float = 0.0
var current_ammo: int = MAX_AMMO
var can_shoot: bool = true
var bullets: Array = []

func _ready():
	# Inicializar balas
	for i in range(MAX_AMMO):
		var bullet = bullet_scene.instantiate()
		add_child(bullet)
		bullets.append(bullet)

func _process(_delta: float) -> void:
	# Detectar la acción de disparo
	if Input.is_action_just_pressed("shoot"):
		disparar()

func _physics_process(delta: float) -> void:
	# Verifica si se quedó sin combustible
	if hud.combustible_val <= 0:
		velocity = Vector2.ZERO
		hud.take_damage(100)
		return
	
	var direction_x = Input.get_axis("ui_left", "ui_right")
	
	# Movimiento vertical constante
	velocity.y = UPWARD_SPEED
	
	# Movimiento lateral y consumo de combustible
	if direction_x != 0:
		velocity.x = move_toward(velocity.x, direction_x * SPEED_X, ACCELERATION * delta)
		fuel_timer += delta
		if fuel_timer >= 1.0:
			hud.use_fuel(FUEL_CONSUMPTION_RATE)
			fuel_timer = 0.0
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	
	move_and_slide()

func disparar():
	if current_ammo <= 0 or !can_shoot:
		return
	
	# Recorre las balas y dispara la que no se esté usando
	for bullet in bullets:
		if not bullet.is_shooting:
			bullet.shoot(pointshoot.global_position, "red")
			current_ammo -= 1
			#hud.update_ammo(current_ammo)
			break

func _on_body_entered(body):
	if body.is_in_group("enemigos"):
		hud.take_damage(10)

func _on_enemy_destroyed():
	hud.add_score(100)
