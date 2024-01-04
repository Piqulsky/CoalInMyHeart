extends Node

const COLD_VAlUE = 0.01
const HEAT_VALUE = 0.20

signal hit

var temperature := 100.0
var enemies := 0

func _ready():
	Globals.hit.connect(_lower_temperature)

func _lower_temperature(quantity):
	temperature -= quantity
