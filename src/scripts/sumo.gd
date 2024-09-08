extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var ROTATION_SPEED = 14
var MOVE_SPEED = 1400

var virtual_joystick_strength = Vector2.ZERO

func _process(delta: float) -> void:
	var force = Vector2.ZERO

	force.x += float(Input.is_action_pressed("ui_right")) - float(Input.is_action_pressed("ui_left"))
	force.y += float(Input.is_action_pressed("ui_up")) - float(Input.is_action_pressed("ui_down"))

	force.x += Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	force.y += Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")

	if force.x > 1:
		force.x -= 1
	elif force.x < -1:
		force.x += 1

	if force.y > 1:
		force.y -= 1
	elif force.y < -1:
		force.y += 1

	force.x += virtual_joystick_strength.x
	force.y += virtual_joystick_strength.y


	if force.length() > 1:
		force = force.normalized()

	rotation_degrees += ROTATION_SPEED * force.x

	var direction = Vector2(0, -1).rotated(rotation)
	print(rotation)
	var movement = direction * MOVE_SPEED * delta * force.y
	

	position += movement

	position.x = clamp(position.x, 0, get_viewport_rect().size.x)
	position.y = clamp(position.y, 0, get_viewport_rect().size.y)

func _on_Joystick_joystick_input(movement_vector):
	virtual_joystick_strength = movement_vector * Vector2(1, -1)
