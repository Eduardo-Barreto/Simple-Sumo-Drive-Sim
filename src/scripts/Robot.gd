extends KinematicBody2D

const ROTATION_SPEED = 7
const MOVE_SPEED = 500

var virtual_joystick_strength = Vector2.ZERO


func _physics_process(delta: float):
	var force = Vector2.ZERO

	# Input do teclado
	force.x += float(Input.is_action_pressed("ui_right")) - float(Input.is_action_pressed("ui_left"))
	force.y += float(Input.is_action_pressed("ui_up")) - float(Input.is_action_pressed("ui_down"))

	# Input do joystick do Xbox 360
	force.x += Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	force.y += Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")

	# Input do joystick virtual
	force.x += virtual_joystick_strength.x
	force.y += virtual_joystick_strength.y

	# Normaliza o vetor de força
	if force.length() > 1:
		force = force.normalized()

	rotation_degrees += ROTATION_SPEED * force.x

	# calcula a posicao a ser incrementada, de acordo com a rotation e a force y
	var direction = Vector2(0, -1).rotated(rotation)
	var movement = direction * MOVE_SPEED * delta * force.y

	position += movement


func _on_Joystick_joystick_input(movement_vector):
	virtual_joystick_strength = movement_vector * Vector2(1, -1)
