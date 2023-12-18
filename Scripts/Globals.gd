extends Node

signal hit

var temperature := 90.0
var enemies := 0

func _ready():
	Globals.hit.connect(_lower_temperature)

func _lower_temperature(quantity):
	temperature -= quantity
