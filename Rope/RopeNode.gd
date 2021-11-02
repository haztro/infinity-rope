extends KinematicBody2D

var joint = false
var pos_old = Vector2.ZERO
var velocity = Vector2.ZERO
var gravity = Vector2(0, 0.8)
var pos = Vector2.ZERO
var colour = Color(1, 1, 1, 1)

var player = null
var x_offset = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_parent().get_node("Player")


#func _process(delta):
#	$Label.text = str(x_offset.x)
