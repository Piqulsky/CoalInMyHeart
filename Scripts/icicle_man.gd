extends CharacterBody2D

@export var player :Node2D
const SPEED = 25.0
var direction := -1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	if global_position.distance_to(player.position) > 1000:
		queue_free()
		Globals.enemies -= 1
	
	if is_on_wall():
		if direction == 1:
			direction = -1
			$Sprite2D.scale.x = 1
		else:
			direction = 1
			$Sprite2D.scale.x = -1
	
	velocity.x = direction * SPEED
	
	if not is_on_floor():
		velocity.y += gravity*delta
	
	move_and_slide()

func damage():
	queue_free()
	Globals.enemies -= 1


func _on_damage_area_2d_body_entered(body):
	if body.name == "FurnaceMan":
		Globals.hit.emit(5)
		queue_free()
		Globals.enemies -= 1
