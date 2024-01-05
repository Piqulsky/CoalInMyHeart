extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_exit_texture_button_button_down():
	visible = false
	Globals.temperature = 100.0
	Globals.enemies = 0
	get_tree().change_scene_to_file("res://Scenes/start_scene.tscn")
