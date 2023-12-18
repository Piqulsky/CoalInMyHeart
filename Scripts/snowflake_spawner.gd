extends StaticBody2D

@export var player :Node2D
var SnoflakeMan = preload("res://Scenes/snowflake_man.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	if position.distance_to(player.position) < 1000.0 and Globals.enemies < 20:
		var s = SnoflakeMan.instantiate()
		s.player = player
		add_child(s)
		Globals.enemies += 1


func damage():
	$ProgressBar.value -= $ProgressBar.step
	if $ProgressBar.value <= 0:
		queue_free()
