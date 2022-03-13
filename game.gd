extends Node2D


const FOOD_COUNT_MAX := 3

var score := 0
var food := []

var body := []
var lenght := 0
var direction := Vector2(0, 0)
var direction_new := Vector2(0, 0)
var time := 0.0
var timer := 0.1


func _ready() -> void:
	set_process(false)
	# init food
	for i in FOOD_COUNT_MAX:
		food.append(Vector2((randi() % 16) * 8, (randi() % 16) * 8))
	# init snake
	body.append(Vector2((randi() % 16) * 8, (randi() % 16) * 8))


func _process(delta: float) -> void:
	time += delta

	if time >= timer:
		# movement
		body.push_front(body[0])
		body[0] += direction * 8
		time = 0
		if body.size() > lenght:
			body.pop_back()
		# collision with body
		if body[0] in body.slice(1, body.size()):
			print("your score is: %s" % score)
			get_tree().reload_current_scene()
		# collision with food
		if body[0] in food:
			food[food.find(body[0])] = Vector2((randi() % 16) * 8, (randi() % 16) * 8)
			body.append(body[0])
			lenght += 1
			score += 1
		# wrap head
		body[0].x = wrapf(body[0].x, 0, 128)
		body[0].y = wrapf(body[0].y, 0, 128)
		# draw
		update()
	# read input
	if Input.is_action_pressed("ui_left"):
		direction_new = Vector2.LEFT
	elif Input.is_action_pressed("ui_right"):
		direction_new = Vector2.RIGHT
	elif Input.is_action_pressed("ui_up"):
		direction_new = Vector2.UP
	elif Input.is_action_pressed("ui_down"):
		direction_new = Vector2.DOWN
	# prevent moving backward
	if direction != direction_new * -1:
		direction = direction_new


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if !is_processing():
			set_process(true)
		# debug
		if event.scancode == KEY_ESCAPE:
			get_tree().quit()
		elif event.scancode == KEY_F2:
			get_tree().reload_current_scene()


func _draw() -> void:
	# food and snake
	for v in food:  draw_rect(Rect2(v, Vector2(8, 8)), Color.yellow, true)
	for v in body: draw_rect(Rect2(v, Vector2(8, 8)), Color.green, true)
