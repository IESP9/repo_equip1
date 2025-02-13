extends Control
@onready var start: Button = $BoxContainer/START
@onready var load: Button = $BoxContainer/LOAD
@onready var exit: Button = $BoxContainer/EXIT

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_start_pressed() -> void:
	pass # Replace with function body.
