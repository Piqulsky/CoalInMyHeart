extends Node2D

enum DIRECTION {NONE, HORIZONTAL, VERTICAL, DIAGONAL}
@export var direction : DIRECTION
@export var range :int
var startPos
var movementProgress := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	startPos = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match direction:
		DIRECTION.NONE:
			return
		DIRECTION.HORIZONTAL:
			movementProgress += delta
			position = position.lerp(startPos + Vector2(startPos.x + range, 0), delta)
		DIRECTION.VERTICAL:
			pass
		DIRECTION.DIAGONAL:
			pass
