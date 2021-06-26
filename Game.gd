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
var nextFigure = []
const initialFigurePosition = Vector2(3, -4)
var figurePosition = initialFigurePosition

# Called when the node enters the scene tree for the first time.
func _ready():
	update_Figure_View_Pos()
	pick_Next_Figure()
	new_Figure()
	$Timer.start(1)

func new_Figure():
	figure = nextFigure
	pick_Next_Figure()
	update_Figure_View()
	figurePosition = initialFigurePosition

func pick_Next_Figure():
	nextFigure = possibleFigures[randi() % possibleFigures.size()]
	update_Radar_View()

func _on_Timer_timeout():
	move_Down()

func move_Down():
	var newPosition = figurePosition
	newPosition.y += 1
	if is_Allowed(figure, newPosition):
		figurePosition = newPosition
	else:
		stop_Figure()
	update_Figure_View_Pos()

func update_Figure_View_Pos():
	figureView.rect_position = Vector2(figurePosition.x * tileSize, figurePosition.y * tileSize)

func update_Figure_View():
	for n in figureView.get_children():
		n.free()
	for y in figure.size():
		for x in figure[y].size():
			if figure[y][x] == 1:
				var newTile = tile.instance()
				newTile.rect_position = Vector2(x * tileSize, y * tileSize)
				figureView.add_child(newTile)

func update_Radar_View():
	for n in $Radar.get_children():
		n.free()
	for y in nextFigure.size():
		for x in nextFigure[y].size():
			if nextFigure[y][x] == 1:
				var newTile = tile.instance()
				newTile.rect_position = Vector2(x * tileSize, y * tileSize)
				$Radar.add_child(newTile)

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
				var newPosition = figurePosition
				newPosition.x -= 1
				if is_Allowed(figure, newPosition):
					figurePosition = newPosition
					update_Figure_View_Pos()
			elif event.scancode == KEY_RIGHT:
				var newPosition = figurePosition
				newPosition.x += 1
				if is_Allowed(figure, newPosition):
					figurePosition = newPosition
					update_Figure_View_Pos()
			elif event.scancode == KEY_DOWN:
				move_Down()
			elif event.scancode == KEY_UP:
				var newFigure = rotate()
				if is_Allowed(newFigure, figurePosition):
					figure = newFigure
					update_Figure_View()

func is_Allowed(fig, position):
	for y in fig.size():
		for x in fig[y].size():
			if fig[y][x] == 1:
				var fieldPos = Vector2(position.x + x, position.y + y)
				if fieldPos.x < 0:
					return false
				elif fieldPos.x >= field[0].size():
					return false
				elif fieldPos.y >= field.size():
					return false
				elif fieldPos.y >= 0 && field[fieldPos.y][fieldPos.x] == 1:
					return false
	return true

func rotate():
	var newFigure = []
	newFigure.resize(figure[0].size())
	for y in newFigure.size():
		newFigure[y] = []
		newFigure[y].resize(figure.size())
		for x in newFigure[y].size():
			newFigure[y][x] = figure[x][figure[0].size() - y - 1]
	return newFigure
