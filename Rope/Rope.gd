extends Node2D

var rope_node = preload("res://Rope/RopeNode.tscn")

var num_nodes = 50
var link_size = 10
var nodes = []
var segs = []
var gravity = Vector2(0, 0.8)
onready var player = get_parent().get_node("Player")
onready var world = get_parent()

var sum = 0
var dropped_pos = Vector2.ZERO
var dropped = 0

func _ready():
	# Create all the rope nodes
	for i in range(num_nodes):
		var rp = rope_node.instance()
		var val = i / float(num_nodes)
		rp.colour = Color(0, 0, 0, 1)
		nodes.append(rp)
		add_child(rp)
		
	# Lock start of rope to player
	nodes[0].joint = true
		
	# Make sure nodes can't collide with themselves or player
	for n in nodes:
		for n1 in nodes:
			n.add_collision_exception_with(n1)
		n.add_collision_exception_with(player)


func _draw():
	for i in range(num_nodes - 1):
		if (nodes[i].position - nodes[i + 1].position).length() <= link_size * 2:
			draw_line(nodes[i].position, nodes[i + 1].position, nodes[i].colour)
		
		
func _process(delta):
	update()
	
	
func _physics_process(delta):
			
	nodes[0].global_position = player.position	
	nodes[0].pos = player.position	
	
	for i in range(num_nodes):
		# If node is off the screen then wrap it back around.
		# Calc node position as if world didn't wrap
		nodes[i].pos = nodes[i].global_position + nodes[i].x_offset * world.world_size
		# Calc distance from player (left -ve right +ve)
		var diff = (nodes[i].pos.x) - player.position.x
		# Calc "number of wraps"
		nodes[i].x_offset.x = int((diff + sign(diff) * world.world_size / 2) / (world.world_size))
		# Wrap pos to position on screen. 
		nodes[i].global_position = nodes[i].pos - nodes[i].x_offset * world.world_size
		
		# Calculate velocity and calc collisions
		if nodes[i].joint == false:
			var vel = gravity
			var temp = nodes[i].pos
			vel += (temp - nodes[i].pos_old)
			nodes[i].pos_old = temp
			if nodes[i].is_on_floor():
				vel.x = lerp(vel.x, 0, 1)
			nodes[i].move_and_slide(vel / delta, Vector2.UP)
			
	# Simulate rope physics 
	for j in range(10):	
		for i in range(num_nodes):
			if i < num_nodes - 1:
				var comp_pos1 = nodes[i].global_position + nodes[i].x_offset * world.world_size
				var comp_pos2 = nodes[i + 1].global_position + nodes[i + 1].x_offset * world.world_size
				var delt = (comp_pos1 - comp_pos2)
				var target = delt.length()
				if target != 0:
					var diff = (target - link_size) / target	
					if nodes[i+1].joint == false and target >= link_size:
						nodes[i+1].move_and_slide((delt * diff) / delta, Vector2.UP)
					if nodes[i].joint == false and target >= link_size:
						nodes[i].move_and_slide((-delt * diff) / delta, Vector2.UP)		
#					nodes[i].rotation = 1.57 + delt.angle()
					



