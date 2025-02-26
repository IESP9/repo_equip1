extends Control #hud del jugador

# Variables para manejar el estado del juego
var score: int = 0
var vida: int = 100
var combustible_val: int = 100

# Referencias a los nodos UI
@onready var hud: Control = $"."
@onready var box_container: BoxContainer = $BoxContainer
@onready var score_label: Label = $BoxContainer/ScoreLabel
@onready var vida_label: Label = $BoxContainer/VidaLabel #decidir entre label o barra, preferentemente barra
@onready var combustible: ProgressBar = $BoxContainer/Combustible
@onready var disparos: Label = $BoxContainer/Disparos
@onready var vida_barra: ProgressBar = $BoxContainer/VidaBarra


func _ready():
	actualizar_hud()

# Función para actualizar la interfaz
func actualizar_hud():
	score_label.text = "Score: " + str(score)
	vida_label.text = "Escudos: " + str(vida) + "%"
	combustible.value = combustible_val

# Función para incrementar la puntuación
func add_score(amount: int) -> void:
	score += amount
	actualizar_hud()

# Función para reducir la vida
func take_damage(amount: int) -> void:
	vida = max(vida - amount, 0)
	actualizar_hud()
	
	if vida <= 0:
		game_over()

# Función para consumir combustible
func use_fuel(amount: float) -> void:
	combustible_val = max(combustible_val - amount, 0)
	actualizar_hud()
	
	if combustible_val <= 0:
		print("¡Combustible agotado!")

# Función de Game Over
func game_over():
	print("¡Juego terminado!")
	# Aquí podrías agregar una pantalla de game over o reiniciar el juego
