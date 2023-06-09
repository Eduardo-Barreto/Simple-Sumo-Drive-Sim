extends Node2D

var collectible = preload("res://scenes/Collectible.tscn")
var score = 0 setget set_score

func set_score(value):
	score = value
	$ScoreLabel.text = str(value)

	if value == 0:
		$ScoreLabel.modulate = Color(1, 0, 0, 1)
	else:
		$ScoreLabel.modulate = Color(0.95, 0.98, 0.04, 1)

	yield(get_tree().create_timer(0.5), 'timeout')
	$ScoreLabel.modulate = Color(1, 1, 1, 1)

func _ready():
	set_score(0)
	on_collectible_collected()

func on_collectible_collected():
	set_score(score + 1)
	var collectible_instance = collectible.instance()
	var spawnAngle = rand_range(0, 2 * PI)
	var spawnPosition = get_viewport_rect().size/2 + Vector2(cos(spawnAngle), sin(spawnAngle)) * rand_range(177, 355)
	collectible_instance.position = spawnPosition
	add_child(collectible_instance)
	collectible_instance.connect("hit", self, "on_collectible_collected")


func _on_Area2D_body_exited(body:Node):
	if body is KinematicBody2D:
		set_score(0)
