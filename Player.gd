extends KinematicBody2D

var GRAVITY = 35
var ACCELERATION = 100
var MAX_SPEED = 150
var JUMP_HEIGHT = -500
var DASH_STRENGTH = 1000

var direction = Vector2.ZERO
var velocity = Vector2.ZERO

var debug = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var friction = false
	
	velocity += Vector2(0, GRAVITY)
	
	if direction != Vector2.ZERO:
		velocity.x = clamp(velocity.x + direction.x * ACCELERATION, -MAX_SPEED, MAX_SPEED)
	else:
		velocity.x = 0
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_HEIGHT
		if friction:
			velocity.x = lerp(velocity.x, 0, 0.5)
	else:
		if friction:
			velocity.x = lerp(velocity.x, 0, 0.05)
			
#	if Input.is_action_just_pressed("dash"):
#		velocity.x += DASH_STRENGTH * direction.x
			
	velocity = move_and_slide(velocity, Vector2.UP)
	
	
func _draw():
	if debug:
		draw_rect(Rect2(-get_viewport().size / 2, get_viewport().size), Color(1, 1, 1, 1), false)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_movement_direction()
	update()
	
func get_movement_direction():
	direction = Vector2(0, 0)
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
