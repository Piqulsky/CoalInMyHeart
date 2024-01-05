extends Node2D

enum DIRECTION {NONE, HORIZONTAL, VERTICAL, DIAGONAL}
const SPEED = 30.0

@export var direction : DIRECTION
@export var range :int

var startPos
var multiplier := 1

# Called when the node enters the scene tree for the first time.
func _ready():
	startPos = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match direction:
		DIRECTION.NONE:
			return
		DIRECTION.HORIZONTAL:
			var goal = Vector2(startPos.x + (multiplier * range), position.y)
			position.x += SPEED * delta * multiplier
			if position.distance_to(goal) < 4:
				multiplier *= -1
		DIRECTION.VERTICAL:
			var goal = Vector2(position.x, startPos.y + (multiplier * range))
			position.y += SPEED * delta * multiplier
			if position.distance_to(goal) < 4:
				multiplier *= -1
		DIRECTION.DIAGONAL:
			var goal = Vector2(startPos.x + (multiplier * range), startPos.y + (multiplier * range))
			position.x += SPEED * delta * multiplier
			position.y += SPEED * delta * multiplier
			if position.distance_to(goal) < 4:
				multiplier *= -1
