extends ColorRect

onready var tile = preload('res://Tile.tscn')
onready var GameLogic = load('res://GameLogic.gd')

onready var figureView = $Field/Figure
onready var tilesView = $Field/Tiles

const tileSize = 20

var game

# Called when the node enters the scene tree for the first time.
func _ready():
	game = GameLogic.new()
	game.init()
	draw()
	$Timer.start(1)

func draw():
	if game.fieldUpdated:
		update_Field_View()
	if game.figureUpdated:
		update_Figure_View()
	if game.figurePositionUpdated:
		update_Figure_View_Pos()
	if game.radarUpdated:
		update_Radar_View()

func _on_Timer_timeout():
	game.move_Down()
	draw()

func update_Figure_View_Pos():
	figureView.rect_position = Vector2(game.figurePosition.x * tileSize, game.figurePosition.y * tileSize)

func update_Figure_View():
	for n in figureView.get_children():
		n.free()
	var figure = game.figure
	for y in figure.size():
		for x in figure[y].size():
			if figure[y][x] == 1:
				var newTile = tile.instance()
				newTile.rect_position = Vector2(x * tileSize, y * tileSize)
				figureView.add_child(newTile)
	game.figureUpdated = false

func update_Radar_View():
	for n in $Radar.get_children():
		n.free()
	var nextFigure = game.nextFigure
	for y in nextFigure.size():
		for x in nextFigure[y].size():
			if nextFigure[y][x] == 1:
				var newTile = tile.instance()
				newTile.rect_position = Vector2(x * tileSize, y * tileSize)
				$Radar.add_child(newTile)
	game.radarUpdated = false

func update_Field_View():
	for n in tilesView.get_children():
		n.free()
	var field = game.field
	for y in field.size():
		for x in field[y].size():
			if field[y][x] == 1:
				var newTile = tile.instance()
				newTile.rect_position = Vector2(x * tileSize, y * tileSize)
				tilesView.add_child(newTile)
	game.fieldUpdated = false

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_LEFT:
				game.move_Left()
				draw()
			elif event.scancode == KEY_RIGHT:
				game.move_Right()
				draw()
			elif event.scancode == KEY_DOWN:
				game.move_Down()
				draw()
			elif event.scancode == KEY_UP:
				game.do_Rotation()
				draw()
