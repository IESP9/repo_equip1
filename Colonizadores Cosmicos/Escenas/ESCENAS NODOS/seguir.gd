class_name seguir extends Node

@export var speed: float = 40  # Velocidad de movimiento
@export var shoot_interval: float = 5.0  # Intervalo entre disparos (5 segundos)
const UPWARD_SPEED = -10.0  # Velocidad constante hacia arriba (en 2D, Y positivo es hacia abajo)

@onready var Heroe: CharacterBody2D = $"../Amazon1"
@onready var parent: CharacterBody2D = $".." #su mismo parente

var start_position


func _ready() -> void:
	start_position = parent.position

func update_velocity():
	pass

func _physics_process(delta) -> void:
	update_velocity()
	parent.move_and_slide()

func disable() -> void:
	process_mode = ProcessMode.PROCESS_MODE_DISABLED 

func _on_areade_seguir_body_entered(body: Node2D) -> void:
	print("¡Disparo!")
	#if body is Heroe:
		#target = body
		#print("¡Disparo!")
