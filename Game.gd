extends ColorRect

onready var tile = preload('res://Tile.tscn')

onready var figureView = $Field/Figure
onready var tilesView = $Field/Tiles

const tileSize = 20

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

var figure = [
	[0, 1, 0, 0],
	[0, 1, 1, 0],
	[0, 0, 1, 0],
	[0, 0, 0, 0]
]
const initialFigurePosition = Vector2(3, -4)
var figurePosition = initialFigurePosition

# Called when the node enters the scene tree for the first time.
func _ready():
	update_Figure_View()
	for y in figure.size():
		for x in figure[y].size():
			if figure[y][x] == 1:
				var newTile = tile.instance()
				newTile.rect_position = Vector2(x * tileSize, y * tileSize)
				figureView.add_child(newTile)
	$Timer.start(1)

func _on_Timer_timeout():
	figurePosition.y += 1
	check_Ground()
	update_Figure_View()

func update_Figure_View():
	figureView.rect_position = Vector2(figurePosition.x * tileSize, figurePosition.y * tileSize)

func check_Ground():
	for y in figure.size():
		for x in figure[y].size():
			if figure[y][x] == 1:
				if figurePosition.y + y + 1 == field.size():
					stop_Figure()
					return

func stop_Figure():
	for y in figure.size():
		for x in figure[y].size():
			if figure[y][x] == 1:
				field[figurePosition.y + y][figurePosition.x + x] = 1
	update_Field_View()
	figurePosition = initialFigurePosition

func update_Field_View():
	for n in tilesView.get_children():
		n.free()
	for y in field.size():
		for x in field[y].size():
			if field[y][x] == 1:
				var newTile = tile.instance()
				newTile.rect_position = Vector2(x * tileSize, y * tileSize)
				tilesView.add_child(newTile)
