extends Area2D

class_name Bullet

@export var speed := 600

enum BulletDirection {
	TOP,
	BOTTOM
}

@export 
var direction : BulletDirection

#var bullet_owner := Main.BulletOwner.PLAYER


func _process(delta):
	match direction:
		BulletDirection.BOTTOM:
			global_position.y += delta * speed
		BulletDirection.TOP:
			global_position.y -= delta * speed


func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

func _on_body_entered(body: Node):
	if body.is_in_group("enemigos de humanos"):  # Asegurar de que los enemigos estén en un grupo llamado "enemigos"
		if hud:
			hud.take_damage(10)  # Resta 10 de vida al chocar con un enemigo



func dead():
	$Anim.play("destroy")
	$Collision.call_deferred("set_disabled", true)


func _on_anim_animation_finished(anim_name):
	if anim_name == "destroy":
		queue_free()
