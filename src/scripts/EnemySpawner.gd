extends Node2D

@export var enemy_scene: PackedScene
@export var dohyo_center: Vector2 = Vector2(640, 360)
@export var dohyo_radius: float = 250.0

var current_enemy: RigidBody2D = null
var dohyo: Area2D = null

func _ready() -> void:
	dohyo = get_parent().find_child("Dohyo", false, false)
	spawn_enemy()

func get_random_position_in_circle() -> Vector2:
	var angle = randf_range(0, TAU)
	var radius = randf_range(0, dohyo_radius)
	return dohyo_center + Vector2(cos(angle), sin(angle)) * radius

func spawn_enemy() -> void:
	if enemy_scene == null:
		return

	current_enemy = enemy_scene.instantiate()
	add_child(current_enemy)
	current_enemy.position = get_random_position_in_circle()
	current_enemy.rotation = randf_range(0, TAU)

	var left_detector = current_enemy.get_node("LeftWheelDetector")
	var right_detector = current_enemy.get_node("RightWheelDetector")

	if left_detector:
		left_detector.area_exited.connect(_on_wheel_exited)
	if right_detector:
		right_detector.area_exited.connect(_on_wheel_exited)

func _on_wheel_exited(area: Area2D) -> void:
	if area == dohyo and current_enemy != null:
		current_enemy.queue_free()
		current_enemy = null
		await get_tree().create_timer(0.5).timeout
		spawn_enemy()
