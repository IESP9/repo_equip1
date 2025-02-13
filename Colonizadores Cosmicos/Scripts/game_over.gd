extends Control

@onready var game_over_panel: Control = $CanvasLayer/GameOverPanel
@onready var restart_button: Button = $CanvasLayer/GameOverPanel/RestartButton
@onready var exit_button: Button = $CanvasLayer/GameOverPanel/ExitButton

func _ready():
	game_over_panel.visible = false  # Al principio, el panel de Game Over está oculto
	restart_button.connect("pressed", self, "_on_restart_pressed")
	exit_button.connect("pressed", self, "_on_exit_pressed")

# Llamar a esta función cuando el juego termine
func game_over():
	game_over_panel.visible = true  # Muestra el mensaje de Game Over

# Función para reiniciar el juego cuando el botón de reiniciar es presionado
func _on_restart_pressed():
	get_tree().reload_current_scene()  # Recarga la escena actual

# Función para salir del juego cuando el botón de salir es presionado
func _on_exit_pressed():
	get_tree().quit()  # Cierra la aplicación
