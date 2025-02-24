extends Control
@onready var start: Button = $BoxContainer/START
@onready var load: Button = $BoxContainer/LOAD
@onready var exit: Button = $BoxContainer/EXIT



func _on_start_pressed() -> void: #boton de start
	get_tree().change_scene_to_file("res://Escenas/ESCENAS NIVELES/nivel test.tscn")

func _on_exit_pressed() -> void: #boton de salir
	get_tree().quit()
