extends Node2D

var heating = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if heating:
		if Globals.temperature < 100:
			Globals.temperature += Globals.HEAT_VALUE

func damage():
	if $Sprite2D.frame < 4:
		$Sprite2D.frame += 1
		Globals.temperature -= 5
	if $Sprite2D.frame == 4:
		$HeatArea2D/Polygon2D.visible = true
		$HeatArea2D/CollisionShape2D.set_deferred("disabled", false)

func freeze():
	queue_free()

func _on_heat_area_2d_body_entered(body):
	if body.name == "FurnaceMan":
		body.inHeat = true
		heating = true
	elif body.has_method("damage"):
		body.damage()


func _on_heat_area_2d_body_exited(body):
	if body.name == "FurnaceMan":
		body.inHeat = false
		heating = false
	elif body.has_method("damage"):
		body.damage()
