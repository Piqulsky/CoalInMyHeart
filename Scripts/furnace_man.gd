extends CharacterBody2D

const SPEED := 300.0
const JUMP_VELOCITY := -500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var startScale :float
var inHeat := false
var pause := false
var chainAnimation := false

func _ready():
	startScale = scale.x

func _physics_process(delta):
	if not pause:
		if not inHeat:
			Globals.temperature -= 0.02
		if not is_on_floor():
			velocity.y += gravity*delta
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
	
		_movement(delta)
	
	
		if Input.is_action_just_pressed("attack_primary"):
			_primary_attack()
		elif Input.is_action_just_pressed("attack_secondary"):
			_secondary_attack()
	else:
		velocity = Vector2(0,0)
		if chainAnimation:
			velocity.y += 250.0*delta
	
	move_and_slide()

func _movement(delta):
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		if direction > 0:
			$CharacterSprite2D.scale.x = startScale
		elif direction < 0:
			$CharacterSprite2D.scale.x = startScale * -1
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED*delta*10)

func _primary_attack():
	$AnimationPlayer.play("attack")
	
func _secondary_attack():
	$AnimationPlayer.play("attack")

func _on_sword_area_2d_body_entered(body):
	if body.is_in_group("enemies") or body.is_in_group("sources"):
		body.damage()
