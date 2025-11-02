extends Node

# Sensibilidade das entradas
@export_group("Sensitivities")
## Joystick sensitivity (0 to 1)
@export var joystick_sensitivity: float = 1.0
## Keyboard sensitivity (0 to 1)
@export var keyboard_sensitivity: float = 1.0

# Função para obter entradas normalizadas (-1 a 1)
func get_normalized_inputs() -> Vector2:
	var left_input = 0.0
	var right_input = 0.0

	var action_forward = Input.get_action_raw_strength("move_forward")
	var action_backward = Input.get_action_raw_strength("move_backward")
	var action_left = Input.get_action_raw_strength("turn_left")
	var action_right = Input.get_action_raw_strength("turn_right")

	right_input = (action_forward - action_backward) + (action_right - action_left)
	left_input = (action_forward - action_backward) + (action_left - action_right)

	var joystick_left = Input.get_axis("left_wheel_negative", "left_wheel_positive")
	var joystick_right = Input.get_axis("right_wheel_negative", "right_wheel_positive")

	if abs(joystick_left) > 0.1:
		right_input += sign(joystick_left)
	if abs(joystick_right) > 0.1:
		left_input += sign(joystick_right)

	left_input = sign(left_input) if abs(left_input) > 0.1 else 0.0
	right_input = sign(right_input) if abs(right_input) > 0.1 else 0.0

	return Vector2(left_input, right_input)
