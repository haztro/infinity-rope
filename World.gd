extends Node2D


var player = null

var tiles_in_camera = 0
var tiles_in_world = 0
var tilemap_rect = null
var last_offset = -2
var world_size = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	player = $Player
	
	tiles_in_camera = int(get_viewport().size.x / $TileMap.cell_size.x)
	tilemap_rect = $TileMap.get_used_rect()
	tiles_in_world = tilemap_rect.size.x
	world_size = tiles_in_world * $TileMap.cell_size.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var offset = get_tile_offset()
	update_tile_map(offset)
	last_offset = offset
	

# Return the index of the tile at the left most edge relative to the player
func get_tile_offset():
	return floor(player.position.x / $TileMap.cell_size.x) - tiles_in_world / 2

func update_tile_map(offset):
	# Determine the direction +ve right, -ve left
	var offset_change = offset - last_offset
	for i in range(abs(offset_change)):	
		# Get map slice we need to move
		var cells = []
		if sign(offset_change) > 0:
			cells = get_tile_map_slice(offset - i - 4)
		elif sign(offset_change) < 0:
			cells = get_tile_map_slice(offset + tiles_in_world + i + 4)
		# Up date the tilemap with the map slices
		for cell in cells:
			$TileMap.set_cell(cell.x + sign(offset_change) * (tiles_in_world), cell.y, 0, false, false, false, $TileMap.get_cell_autotile_coord(cell.x, cell.y))
			$TileMap.set_cell(cell.x, cell.y, -1, false, false, false, $TileMap.get_cell_autotile_coord(cell.x, cell.y))
			
	for i in range(4):
		# Get map slice we need to move
		var cells = []
		if sign(offset_change) > 0:
			cells = get_tile_map_slice(offset + i)
		elif sign(offset_change) < 0:
			cells = get_tile_map_slice(offset + tiles_in_world - i)
		# Up date the tilemap with the map slices
		for cell in cells:
			$TileMap.set_cell(cell.x + sign(offset_change) * (tiles_in_world), cell.y, 0, false, false, false, $TileMap.get_cell_autotile_coord(cell.x, cell.y))

func get_tile_map_slice(pos):
	var height = tilemap_rect.size.y
	var slice = []
	for i in range(height):
		var cell = $TileMap.get_cell(pos, tilemap_rect.position.y + i)
		if cell != TileMap.INVALID_CELL:
			slice.append(Vector2(pos, tilemap_rect.position.y + i))	
	return slice
