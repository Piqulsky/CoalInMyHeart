extends CharacterBody2D

const SPEED := 270.0
const JUMP_VELOCITY := -500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var startScale :float
var inHeat := false
var pause := false
var chainAnimation := false
var dashing := false
var dashedSinceLanding := false
var dashPoint := Vector2(0,0)
var jumpHeat := 0.0
var extraVelocity := Vector2(0,0)

func _ready():
	startScale = scale.x

func _physics_process(delta):
	if not pause:
		if is_on_floor() and not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("idle")
		if dashing:
			position = position.lerp(dashPoint, delta * 10)
			
		if not inHeat:
			Globals.temperature -= Globals.COLD_VAlUE
		if not is_on_floor():
			if not $AnimationPlayer.is_playing():
				$CharacterSprite2D.frame = 5
			velocity.y += gravity*delta
		else:
			dashedSinceLanding = false
		
		if Input.is_action_pressed("jump") and velocity.x == 0 and is_on_floor():
			jumpHeat += delta
		
		if Input.is_action_just_released("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			$AnimationPlayer.play("jump")
			if jumpHeat > 1.0:
				jumpHeat = 0.0
				_heated_jump()
	
		_movement(delta)
	
		if Input.is_action_just_pressed("attack_primary"):
			_primary_attack()
		elif Input.is_action_just_pressed("attack_secondary") and not dashedSinceLanding:
			_secondary_attack($CharacterSprite2D.scale.x)
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
		if $AnimationPlayer.current_animation == "attack":
			velocity.x /= 3
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED*delta*10) + extraVelocity.x

func _primary_attack():
	$AnimationPlayer.play("attack")
	
func _secondary_attack(dir):
	dashedSinceLanding = true
	dashing = true
	dashPoint = position + Vector2(64 * dir, 0)
	$AnimationPlayer.play("dash")

func _on_animation_player_animation_finished(anim_name):
	dashing = false

func _heated_jump():
	velocity.y += JUMP_VELOCITY * 0.3
	$AnimationPlayer.play("heat_jump")

func _on_sword_area_2d_body_entered(body):
	if body.is_in_group("enemies") or body.is_in_group("sources"):
		body.damage()

func _on_dash_area_2d_body_entered(body):
	if body.is_in_group("enemies") or body.is_in_group("sources"):
		body.damage()

func _on_jump_area_2d_body_entered(body):
	if body.is_in_group("enemies") or body.is_in_group("sources"):
		body.damage()

