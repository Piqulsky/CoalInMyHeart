extends CharacterBody2D

@export var player :Node2D
const SPEED = 75.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	_make_path()

func _physics_process(delta):
	if global_position.distance_to(player.position) > 1000:
		queue_free()
		Globals.enemies -= 1
	
	var direction = to_local($NavigationAgent2D.get_next_path_position()).normalized()
	velocity = direction * SPEED
	
	if move_and_slide():
		var collision = move_and_collide(velocity*delta)
		if collision:
			if collision.get_collider().get_name() == "FurnaceMan":
				Globals.hit.emit(5)
				queue_free()
				Globals.enemies -= 1

func damage():
	queue_free()
	Globals.enemies -= 1

func _make_path():
	$NavigationAgent2D.target_position = player.global_position


func _on_timer_timeout():
	_make_path()
