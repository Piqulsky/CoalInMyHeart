extends CharacterBody2D

const SPEED = 30.0
const KNOCKUP_VELOCITY := -500.0
@export var player :Node2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") / 2
var pause := true
var lives := 2
@onready var animPlayer := $AnimationPlayer

var movementStart :Vector2
var movementEdit :Vector2
var movementEnd :Vector2
var movementProgress := 1.0
var progressMultiplier := 1.0
var movementDelay := 0.0

func _ready():
	_makepath()

func _physics_process(delta):
	if not pause:
		if not is_on_floor():
			velocity.y += gravity * delta
		
		var direction = to_local($NavigationAgent2D.get_next_path_position()).normalized()
		velocity.x = direction.x * SPEED

		move_and_slide()
		
		
	elif animPlayer.is_playing():
		if movementDelay > 0.0:
			movementDelay -= delta
		elif movementProgress != 1.0:
			if global_position.x + 60 >= 224 or global_position.x - 60 <= -224:
				return
			movementProgress += delta * progressMultiplier
			global_position = _quadratic_bezier(movementStart, movementEdit, movementEnd, movementProgress)

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r

func damage():
	var pg = $ProgressBar
	pg.value -= pg.step
	if pg.value <= 0:
		lives -= 1
		if lives < 0:
			queue_free()
		else:
			get_node("LifeSprite2D" + str(lives+1)).visible = false
			pg.value = 100
		

func _makepath():
	$NavigationAgent2D.target_position = player.global_position

func _on_path_timer_timeout():
	_makepath()

func _on_start_timer_timeout():
	pause = false


func _on_animation_player_animation_finished(anim_name):
	pause = false

func _deal_damage(quantity):
	var man = get_node("/root/BossScene/FurnaceMan") as CharacterBody2D
	man.velocity.y = KNOCKUP_VELOCITY
	Globals.temperature -= quantity

func _on_attack_timer_timeout():
	var dist = global_position.distance_to(player.global_position)
	#print(dist)
	if dist > 200 and lives == 2:
		movementProgress = 0.0
		movementDelay = 0.0
		progressMultiplier = 0.5
		pause = true
		animPlayer.play("slam") 
		movementStart = global_position
		if global_position.x > player.global_position.x:
			movementEdit = Vector2(global_position.x - (global_position.distance_to(player.global_position)/2), -200)
		else:
			movementEdit = Vector2(global_position.x + (global_position.distance_to(player.global_position)/2), -200)
		movementEnd = Vector2(player.global_position.x, global_position.y)
	elif dist > 120 and lives == 2:
		movementProgress = 0.0
		movementDelay = 3.0
		progressMultiplier = 2.0
		pause = true
		animPlayer.play("pierce") 
		movementStart = global_position
		if global_position.x > player.global_position.x:
			movementEdit = Vector2(global_position.x - (global_position.distance_to(player.global_position)/2), global_position.y)
			movementEnd = Vector2(global_position.x - 224, global_position.y)
			$PierceArea2D.scale.x = 1
		else:
			movementEdit = Vector2(global_position.x + (global_position.distance_to(player.global_position)/2), global_position.y)
			movementEnd = Vector2(global_position.x + 224, global_position.y)
			$PierceArea2D.scale.x = -1
	elif dist < 90 and lives == 2:
		movementProgress = 1.0
		progressMultiplier = 1.0
		movementDelay = 0.0
		pause = true
		if global_position.x > player.global_position.x:
			$MeleeArea2D.scale.x = 1
		else:
			$MeleeArea2D.scale.x = -1
		animPlayer.play("melee") 


func _on_slam_area_2d_body_entered(body):
	if body.name == "FurnaceMan":
		_deal_damage(20)


func _on_pierce_area_2d_body_entered(body):
	if body.name == "FurnaceMan":
		_deal_damage(10)


func _on_melee_area_2d_body_entered(body):
	if body.name == "FurnaceMan":
		_deal_damage(15)
