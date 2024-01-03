extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Globals.temperature < 0:
		get_node("/root/" + get_tree().get_current_scene().get_name() + "/FurnaceMan").visible = false
		visible = true


func _on_restart_texture_button_button_down():
	get_node("/root/" + get_tree().get_current_scene().get_name() + "/FurnaceMan").visible = false
	visible = false
	Globals.temperature = 100.0
	Globals.enemies = 0
	get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")


func _on_exit_texture_button_button_down():
	get_node("/root/" + get_tree().get_current_scene().get_name() + "/FurnaceMan").visible = false
	visible = false
	Globals.temperature = 100.0
	Globals.enemies = 0
	get_tree().change_scene_to_file("res://Scenes/start_scene.tscn")
