extends CharacterBody2D

@export_group("Robot constants")
## Rotação máxima do motor em RPM
@export var motor_rpm: float = 6380
## Tensão nominal do motor em V
@export var motor_voltage: float = 12.0
## Tensão nominal de uma celula em V
@export var cell_voltage: float = 4.2
## Tensão nominal da bateria em V
@export var battery_cells: float = 8
## Raio da roda em mm
@export var wheel_radius_mm: float = 23
## Distância entre rodas em mm
@export var wheels_distance_mm: float = 94.8
## Fator de redução (1.0 para sem redução)
@export var reduction_factor: float = 7.92

@onready var input_manager: Node = $RobotInput

var left_input: float = 0.0
var right_input: float = 0.0
var counter = 0

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
	# Configurações físicas baseadas na escala global
	_scale = Global.world_scale
	wheels_distance_mm *= _scale
	wheel_radius_mm *= _scale
	battery_voltage = cell_voltage * battery_cells

func _physics_process(delta: float) -> void:
	var inputs = input_manager.get_normalized_inputs()
	left_input = inputs.x
	right_input = inputs.y

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
	# Velocidade física (mm/s) de cada roda
	max_speed = (motor_rpm / 60) * (2 * PI * wheel_radius_mm) * (battery_voltage / motor_voltage)

	# Aplicar fator de redução
	reduced_max_speed = max_speed / reduction_factor

	# Velocidade das rodas, ajustada pelas entradas normalizadas
	left_wheel_speed = left_input * reduced_max_speed
	right_wheel_speed = right_input * reduced_max_speed
	

	# Calcular velocidades linear e angular
	linear_speed = (right_wheel_speed + left_wheel_speed) / 2.0
	angular_speed = (right_wheel_speed - left_wheel_speed) / wheels_distance_mm / 2

	counter += 1
	if counter % 10 == 1:
		pass# _print_parameters()

	# Movimento do robô
	velocity = Vector2(linear_speed, 0).rotated(rotation)
	move_and_slide()
	rotation += angular_speed * delta
