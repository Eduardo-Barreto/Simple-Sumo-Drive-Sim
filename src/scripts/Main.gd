extends Node2D

var collectible = preload("res://scenes/Collectible.tscn")
var score = 0

func _ready():
	on_collectible_collected()

func on_collectible_collected():
	score += 1
	var collectible_instance = collectible.instance()
	var spawnAngle = rand_range(0, 2 * PI)
	var spawnPosition = get_viewport_rect().size/2 + Vector2(cos(spawnAngle), sin(spawnAngle)) * rand_range(0, 355)
	collectible_instance.position = spawnPosition
	add_child(collectible_instance)
	collectible_instance.connect("hit", self, "on_collectible_collected")

