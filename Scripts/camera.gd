extends Camera2D

@export var follow :Node2D

func _physics_process(delta):
	position.x = follow.position.x
