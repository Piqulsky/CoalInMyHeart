extends Node2D

var CoalPile = preload("res://Scenes/coal_pile.tscn")
var LavaPool = preload("res://Scenes/lava_pool.tscn")

@export var boss : Node2D
var switch := true # true == Coal Pile ; false == Lava Pool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_spawn_timer_timeout(): # Spawn range.x = -192 --0-- 192
	if get_child_count() < 2:
		var locationX = 0
		if boss.global_position.x > 0:
			locationX = randi_range(-192, 0)
		else:
			locationX = randi_range(0, 192)
		if switch:
			var c = CoalPile.instantiate() as StaticBody2D
			c.position.x = locationX
			c.collision_layer = 2
			c.collision_mask = 2
			add_child(c)
			switch = false
		else:
			var l = LavaPool.instantiate() as Node2D
			l.position.x = locationX
			add_child(l)
			switch = true
