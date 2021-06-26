extends ColorRect

onready var tile = preload('res://Tile.tscn')

onready var figureView = $Field/Figure
onready var tilesView = $Field/Tiles

const tileSize = 20

const possibleFigures = [
	[
		[1, 0],
		[1, 1],
		[0, 1]
	],
	[
		[0, 1],
		[1, 1],
		[1, 0]
	],
	[
		[1, 1],
		[0, 1],
		[0, 1]
	],
	[
		[1, 1],
		[1, 0],
		[1, 0]
	],
	[
		[0, 1, 0],
		[1, 1, 1]
	],
	[
		[1, 1],
		[1, 1]
	],
	[
		[1, 1, 1, 1]
	]
]

var field = [
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
]

var figure = []
const initialFigurePosition = Vector2(3, -4)
var figurePosition = initialFigurePosition

# Called when the node enters the scene tree for the first time.
func _ready():
	update_Figure_View()
	new_Figure()
	$Timer.start(1)

func new_Figure():
	figure = possibleFigures[randi() % possibleFigures.size()]
	for n in figureView.get_children():
		n.free()
	for y in figure.size():
		for x in figure[y].size():
			if figure[y][x] == 1:
				var newTile = tile.instance()
				newTile.rect_position = Vector2(x * tileSize, y * tileSize)
				figureView.add_child(newTile)
	figurePosition = initialFigurePosition

func _on_Timer_timeout():
	figurePosition.y += 1
	check_Ground()
	update_Figure_View()

func update_Figure_View():
	figureView.rect_position = Vector2(figurePosition.x * tileSize, figurePosition.y * tileSize)

func check_Ground():
	for y in figure.size():
		var rowBelow = figurePosition.y + y + 1
		if rowBelow < 0:
			continue
		for x in figure[y].size():
			if figure[y][x] == 1:
				if rowBelow == field.size():
					stop_Figure()
					return
				if field[rowBelow][figurePosition.x + x] == 1:
					stop_Figure()
					return

func stop_Figure():
	for y in figure.size():
		for x in figure[y].size():
			if figure[y][x] == 1:
				field[figurePosition.y + y][figurePosition.x + x] = 1
	update_Field_View()
	new_Figure()

func update_Field_View():
	for n in tilesView.get_children():
		n.free()
	for y in field.size():
		for x in field[y].size():
			if field[y][x] == 1:
				var newTile = tile.instance()
				newTile.rect_position = Vector2(x * tileSize, y * tileSize)
				tilesView.add_child(newTile)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_LEFT:
				if figurePosition.x > 0:
					figurePosition.x -= 1
					update_Figure_View()
			elif event.scancode == KEY_RIGHT:
				if figurePosition.x < field[0].size() - figure[0].size():
					figurePosition.x += 1
					update_Figure_View()
