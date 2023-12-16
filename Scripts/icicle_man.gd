extends CharacterBody2D

@export var player :Node2D
const SPEED = 25.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	_make_path()

func _physics_process(delta):
	var direction = to_local($NavigationAgent2D.get_next_path_position()).normalized()
	velocity = direction * SPEED
	
	if not is_on_floor():
		velocity.y += gravity*delta*7
	
	if move_and_slide():
		var collision = move_and_collide(velocity*delta)
		if collision:
			if collision.get_collider().get_name() == "FurnaceMan":
				Globals.hit.emit(5)
				queue_free()

func damage():
	queue_free()

func _make_path():
	$NavigationAgent2D.target_position = player.global_position

func _on_timer_timeout():
	_make_path()
