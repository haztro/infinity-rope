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
	
	for i in range(num_nodes):
		var rp = rope_node.instance()
		var val = i / float(num_nodes)
#		rp.modulate = Color(val, val, val, 1)
		rp.colour = Color(1, 1, 1, 1)
		nodes.append(rp)
		add_child(rp)
		
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
		nodes[i].pos = nodes[i].global_position + nodes[i].x_offset * world.world_size
		var diff = (nodes[i].pos.x) - player.position.x
		nodes[i].x_offset.x = int((diff + sign(diff) * world.world_size / 2) / (world.world_size))
		nodes[i].global_position = nodes[i].pos - nodes[i].x_offset * world.world_size
		nodes[i].old_offset = nodes[i].x_offset
		
		if nodes[i].joint == false:
			var vel = gravity
			var temp = nodes[i].pos
#			var temp = nodes[i].global_position
			vel += (temp - nodes[i].pos_old)
			nodes[i].pos_old = temp
			if nodes[i].is_on_floor():
				vel.x = lerp(vel.x, 0, 1)
			nodes[i].move_and_slide(vel / delta, Vector2.UP)
			
	var sum = 0
	for j in range(10):	
#		sum = 0
		for i in range(num_nodes):
			if i < num_nodes - 1:
				var comp_pos1 = nodes[i].global_position + nodes[i].x_offset * world.world_size
				var comp_pos2 = nodes[i + 1].global_position + nodes[i + 1].x_offset * world.world_size
				var delt = (comp_pos1 - comp_pos2)
				var target = delt.length()
#				sum += target
				if target != 0:
					var diff = (target - link_size) / target	
					if nodes[i+1].joint == false and target >= link_size:
						nodes[i+1].move_and_slide((delt * diff) / delta, Vector2.UP)
						sum += 1
					if nodes[i].joint == false and target >= link_size:
						nodes[i].move_and_slide((-delt * diff) / delta, Vector2.UP)
						sum += 1
						
#					nodes[i].rotation = 1.57 + delt.angle()
					
	print(sum)



