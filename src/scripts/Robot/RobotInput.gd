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
	
	var action_forward = int(Input.is_action_pressed("move_forward")) * keyboard_sensitivity
	var action_backward = int(Input.is_action_pressed("move_backward")) * keyboard_sensitivity
	var action_left = int(Input.is_action_pressed("turn_left")) * keyboard_sensitivity
	var action_right = int(Input.is_action_pressed("turn_right")) * keyboard_sensitivity
	
	right_input = (action_forward - action_backward) + (action_left - action_right)
	left_input = (action_forward - action_backward) + (action_right - action_left)

	# Joystick (modo japonês)
	left_input += Input.get_axis("left_wheel_negative", "left_wheel_positive") * joystick_sensitivity
	right_input += Input.get_axis("right_wheel_negative", "right_wheel_positive") * joystick_sensitivity

	# Retornar valores normalizados
	return Vector2(clamp(left_input, -1.0, 1.0), clamp(right_input, -1.0, 1.0))
