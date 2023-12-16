extends Node2D

var heating := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("jump") and not heating:
		$AnimationPlayer.stop()
		var body = get_node("/root/MainScene/FurnaceMan")
		body.pause = false
		body.chainAnimation = false
	elif heating:
		if Globals.temperature < 100:
			Globals.temperature += 0.04


func _on_handle_area_2d_body_entered(body):
	if body.name == "FurnaceMan":
		body.pause = true
		body.chainAnimation = true
		$AnimationPlayer.play("unlock")


func _on_animation_player_animation_finished(anim_name):
	$ChainPolygon2D/HandleArea2D/CollisionShape2D.set_deferred("disabled", true)
	var body = get_node("/root/MainScene/FurnaceMan")
	body.pause = false
	body.chainAnimation = false


func _on_heat_area_2d_body_entered(body):
	if body.name == "FurnaceMan":
		body.inHeat = true
		heating = true
	elif body.has_method("damage"):
		body.damage()


func _on_heat_area_2d_body_exited(body):
	if body.name == "FurnaceMan":
		body.inHeat = false
		heating = false
	elif body.has_method("damage"):
		body.damage()
