extends KinematicBody2D

var ROTATION_SPEED = 14
var MOVE_SPEED = 1400

var virtual_joystick_strength = Vector2.ZERO

func _ready():
	get_parent().get_node('MoveSpeed').text = str(MOVE_SPEED)
	get_parent().get_node('RotationSpeed').text = str(ROTATION_SPEED)


func _physics_process(delta: float):
	if Input.is_action_just_pressed("ui_accept"):
		position = get_viewport_rect().size / 2

	var force = Vector2.ZERO

	# Input do teclado
	force.x += float(Input.is_action_pressed("ui_right")) - float(Input.is_action_pressed("ui_left"))
	force.y += float(Input.is_action_pressed("ui_up")) - float(Input.is_action_pressed("ui_down"))

	# Input do joystick do Xbox 360
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

	# clamp postion
	position.x = clamp(position.x, 0, get_viewport_rect().size.x)
	position.y = clamp(position.y, 0, get_viewport_rect().size.y)


func _on_Joystick_joystick_input(movement_vector):
	virtual_joystick_strength = movement_vector * Vector2(1, -1)


func _on_MoveSpeed_text_entered(new_text:String):
	MOVE_SPEED = float(new_text)


func _on_RotationSpeed_text_entered(new_text:String):
	ROTATION_SPEED = float(new_text)
