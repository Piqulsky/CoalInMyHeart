extends Camera2D

@export var follow :Node2D

func _physics_process(delta):
	position.x = follow.position.x


func _on_level_doorway_area_2d_body_entered(body):
	if body.name == "FurnaceMan":
		get_tree().change_scene_to_file("res://Scenes/boss_scene.tscn")
