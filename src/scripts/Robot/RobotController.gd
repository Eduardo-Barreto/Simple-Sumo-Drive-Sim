extends CharacterBody2D

@export_group("Robot constants")
## Rotação máxima do motor em RPM
@export var motor_rpm: float = 6380
## Tensão nominal do motor em V
@export var motor_voltage: float = 12
## Tensão nominal de uma celula em V
@export var cell_voltage: float = 4.2
## Tensão nominal da bateria em V
@export var battery_cells: float = 8
## Raio da roda em mm
@export var wheel_radius_mm: float = 23
## Distância entre rodas em mm
@export var wheels_distance_mm: float = 75
## Fator de redução (1.0 para sem redução)
@export var reduction_factor: float = 7.92

@onready var input_manager: Node = $RobotInput
@onready var left_wheel_detector: Area2D = $LeftWheelDetector
@onready var right_wheel_detector: Area2D = $RightWheelDetector

var left_input: float = 0.0
var right_input: float = 0.0
var counter = 0

var initial_position: Vector2
var initial_rotation: float

var left_wheel_in_arena: bool = true
var right_wheel_in_arena: bool = true

var _scale
var battery_voltage
var max_speed
var reduced_max_speed
var left_wheel_speed
var right_wheel_speed
var linear_speed
var angular_speed

func _ready() -> void:
	_print_parameters()

	_scale = Global.world_scale
	wheels_distance_mm *= _scale
	wheel_radius_mm *= _scale
	battery_voltage = cell_voltage * battery_cells

	initial_position = position
	initial_rotation = rotation

	left_wheel_detector.area_exited.connect(_on_left_wheel_exited)
	left_wheel_detector.area_entered.connect(_on_left_wheel_entered)
	right_wheel_detector.area_exited.connect(_on_right_wheel_exited)
	right_wheel_detector.area_entered.connect(_on_right_wheel_entered)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		reset_robot()
		return

	var inputs = input_manager.get_normalized_inputs()
	left_input = inputs.x
	right_input = inputs.y

	_update_visual_state()
	_apply_movement(delta)

func _print_parameters() -> void:
	print('motor_rpm: ', motor_rpm)
	print('motor_voltage: ', motor_voltage)
	print('battery_voltage: ', battery_voltage)
	print('wheel_radius_mm: ', wheel_radius_mm)
	print('wheels_distance_mm: ', wheels_distance_mm)
	print('reduction_factor: ', reduction_factor)
	print('max_speed: ', max_speed)
	print('reduced_max_speed: ', reduced_max_speed)
	print('left_wheel_speed: ', left_wheel_speed)
	print('right_wheel_speed: ', right_wheel_speed)
	print('linear_speed: ', linear_speed)
	print('angular_speed: ', angular_speed)

func _apply_movement(delta: float) -> void:
	max_speed = (motor_rpm / 60) * (2 * PI * wheel_radius_mm) * (battery_voltage / motor_voltage)
	reduced_max_speed = max_speed / reduction_factor

	left_wheel_speed = left_input * reduced_max_speed if right_wheel_in_arena else 0.0
	right_wheel_speed = right_input * reduced_max_speed if left_wheel_in_arena else 0.0

	linear_speed = (right_wheel_speed + left_wheel_speed) / 2.0
	angular_speed = (right_wheel_speed - left_wheel_speed) / wheels_distance_mm / 2

	counter += 1
	if counter % 10 == 1:
		pass

	velocity = Vector2(linear_speed, 0).rotated(rotation)
	move_and_slide()
	rotation += angular_speed * delta

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody2D:
			var forward_direction = Vector2.RIGHT.rotated(rotation)
			var collision_direction = collision.get_normal() * -1
			var dot_product = forward_direction.dot(collision_direction)

			if dot_product > 0.5:
				var push_force = 80000.0
				collider.apply_central_force(collision_direction * push_force * _scale)

func _update_visual_state() -> void:
	if not left_wheel_in_arena and not right_wheel_in_arena:
		modulate = Color.RED
	else:
		modulate = Color.WHITE

func reset_robot() -> void:
	position = initial_position
	rotation = initial_rotation
	velocity = Vector2.ZERO
	left_input = 0.0
	right_input = 0.0
	left_wheel_in_arena = true
	right_wheel_in_arena = true
	modulate = Color.WHITE

func _on_left_wheel_exited(area: Area2D) -> void:
	if area.name == "Dohyo":
		left_wheel_in_arena = false

func _on_left_wheel_entered(area: Area2D) -> void:
	if area.name == "Dohyo":
		left_wheel_in_arena = true

func _on_right_wheel_exited(area: Area2D) -> void:
	if area.name == "Dohyo":
		right_wheel_in_arena = false

func _on_right_wheel_entered(area: Area2D) -> void:
	if area.name == "Dohyo":
		right_wheel_in_arena = true
