extends CharacterBody2D


@export var speed = 1000 * Global.world_scale
@export var wheels_distance = 0.05 * Global.world_scale


var virtual_joystick_strength = Vector2.ZERO


func _process(delta: float) -> void:
	var rotation_speed = speed / wheels_distance
	print(rotation_speed)
	# Obtendo a força das rodas diretamente das entradas
	var right_wheel_force = Input.get_axis("right_wheel_negative", "right_wheel_positive")
	var left_wheel_force = Input.get_axis("left_wheel_negative", "left_wheel_positive")

	# Calculando a direção inicial (para frente)
	var direction = Vector2(0, -1)
		
	var action_forward = int(Input.is_action_pressed("move_forward"))
	var action_backward = int(Input.is_action_pressed("move_backward"))
	var action_left = int(Input.is_action_pressed("move_left"))
	var action_right = int(Input.is_action_pressed("move_right"))

	right_wheel_force += (action_forward - action_backward) + (action_left - action_right)
	left_wheel_force += (action_forward - action_backward) + (action_right - action_left)

	# Movimentação diferencial para cada roda
	var left_movement = direction.rotated(rotation) * speed * delta * left_wheel_force
	var right_movement = direction.rotated(rotation) * speed * delta * right_wheel_force

	# Ajusta a rotação do robô com base na diferença entre as forças das rodas
	rotation += (rotation_speed * (left_wheel_force - right_wheel_force) * delta)

	# Calcula a posição final com base nos movimentos individuais de cada roda
	position += (left_movement + right_movement) / 2

	# Limita a posição do robô dentro dos limites da tela
	position.x = clamp(position.x, 0, get_viewport_rect().size.x)
	position.y = clamp(position.y, 0, get_viewport_rect().size.y)


#func _process(delta: float) -> void:
	#var force = Vector2.ZERO
#
	#force.x += float(Input.is_action_pressed("move_right")) - float(Input.is_action_pressed("move_left"))
	#force.y += float(Input.is_action_pressed("move_forward")) - float(Input.is_action_pressed("move_backward"))
#
	##force.x += Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	##force.y += Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
#
	#if force.x > 1:
		#force.x -= 1
	#elif force.x < -1:
		#force.x += 1
#
	#if force.y > 1:
		#force.y -= 1
	#elif force.y < -1:
		#force.y += 1
		#
	#print(virtual_joystick_strength.x)
	#print(virtual_joystick_strength.y)
#
	#force.x += virtual_joystick_strength.x
	#force.y += virtual_joystick_strength.y
#
#
	#if force.length() > 1:
		#force = force.normalized()
#
	#rotation_degrees += ROTATION_SPEED * force.x
#
	#var direction = Vector2(0, -1).rotated(rotation)
	#print(rotation)
	#var movement = direction * MOVE_SPEED * delta * force.y
	#
#
	#position += movement
#
	#position.x = clamp(position.x, 0, get_viewport_rect().size.x)
	#position.y = clamp(position.y, 0, get_viewport_rect().size.y)

func _on_Joystick_joystick_input(movement_vector):
	virtual_joystick_strength = movement_vector * Vector2(1, -1)
