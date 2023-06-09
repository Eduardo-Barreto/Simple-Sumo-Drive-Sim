extends TouchScreenButton

signal joystick_input()

var move_vector = Vector2(0, 0)
var joystick_active = false

func calculate_move_vector(event_position):
	var joystick_center = position + Vector2(90, 90)
	return (event_position - joystick_center).normalized()

func _input(event):
	if (event is InputEventScreenTouch or event is InputEventScreenDrag):
		if is_pressed():
			move_vector = calculate_move_vector(event.position)
			joystick_active = true

	if event is InputEventScreenTouch and not event.pressed:
		joystick_active = false

func _process(_delta):
	emit_signal("joystick_input", move_vector)
	if not joystick_active:
		move_vector = Vector2(0, 0)
