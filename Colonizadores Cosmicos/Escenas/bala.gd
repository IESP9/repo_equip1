extends Area2D  # La bala usa Area2D para detectar colisiones

@export var speed: float = 400  # Velocidad de la bala
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D  # Referencia al sprite animado

func _ready():
	hide()  # La bala empieza oculta
	connect("body_entered", _on_bala_collision)  # Conectar la señal de colisión correctamente

func shoot(start_position, color):
	position = start_position  
	show()  
	sprite.play("simple_" + color)  # Cambia la animación de la bala según el color

func _process(delta):
	if visible:
		position.y -= speed * delta  # Mueve la bala hacia arriba

# Maneja la colisión con cualquier objeto
func _on_bala_collision(_body):
	hide()  # Oculta la bala para reutilizarla
