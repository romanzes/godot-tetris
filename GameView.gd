extends ColorRect

onready var tile = preload('res://Tile.tscn')

onready var figureView = $Field/Figure
onready var tilesView = $Field/Tiles

const tileSize = 20

var field = [
	[null, null, null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null, null, null],
]

onready var controller = $GameController

# Called when the node enters the scene tree for the first time.
func _ready():
	$GameController.init()
	start_Timer()

func start_Timer():
	$Timer.start(1)

func _on_Timer_timeout():
	controller.move_Down()

func update_Figure_View_Pos():
	var newPosition = Vector2(controller.figurePosition.x * tileSize, controller.figurePosition.y * tileSize)
	$Animator.interpolate_property(figureView, 'rect_position', figureView.rect_position, newPosition, 0.1, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Animator.start()

func update_Figure_View():
	figureView.rect_position = Vector2(controller.figurePosition.x * tileSize, controller.figurePosition.y * tileSize)
	for n in figureView.get_children():
		n.free()
	var figure = controller.figure
	for y in figure.size():
		for x in figure[y].size():
			if figure[y][x] == 1:
				var newTile = tile.instance()
				newTile.rect_position = Vector2(x * tileSize, y * tileSize)
				figureView.add_child(newTile)

func update_Radar_View():
	for n in $Radar.get_children():
		n.free()
	var nextFigure = controller.nextFigure
	for y in nextFigure.size():
		for x in nextFigure[y].size():
			if nextFigure[y][x] == 1:
				var newTile = tile.instance()
				newTile.rect_position = Vector2(x * tileSize, y * tileSize)
				$Radar.add_child(newTile)

func update_Field_View():
	for n in tilesView.get_children():
		n.free()
	for y in controller.field.size():
		for x in controller.field[y].size():
			if controller.field[y][x] == 1:
				field[y][x] = tile.instance()
				field[y][x].rect_position = Vector2(x * tileSize, y * tileSize)
				tilesView.add_child(field[y][x])

func remove_Line(lineNumber):
	for x in field[lineNumber].size():
		if field[lineNumber][x] != null:
			field[lineNumber][x].destroy()
			yield(get_tree().create_timer(0.05), "timeout")
	$Timer.stop()
	yield(get_tree().create_timer(0.3), "timeout")
	start_Timer()
	update_Field_View()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_LEFT:
				controller.move_Left()
			elif event.scancode == KEY_RIGHT:
				controller.move_Right()
			elif event.scancode == KEY_DOWN:
				controller.move_Down()
			elif event.scancode == KEY_UP:
				controller.do_Rotation()
