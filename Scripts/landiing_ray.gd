extends RayCast2D

@export var animPlayer :AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_colliding() and not get_parent().is_on_floor() and not animPlayer.is_playing():
		animPlayer.play("land")
