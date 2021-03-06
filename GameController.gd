extends Node

onready var view = get_node("/root/GameView")

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
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
]

var figure = []
var nextFigure = []
var figurePosition = initialFigurePosition
const initialFigurePosition = Vector2(3, -4)

# Called when the node enters the scene tree for the first time.
func init():
	pick_Next_Figure()
	new_Figure()
	view.update_Field_View()

func new_Figure():
	figure = nextFigure
	figurePosition = initialFigurePosition
	view.update_Figure_View()
	pick_Next_Figure()

func pick_Next_Figure():
	nextFigure = possibleFigures[randi() % possibleFigures.size()]
	view.update_Radar_View()

func move_Left():
	var newPosition = figurePosition
	newPosition.x -= 1
	if is_Allowed(figure, newPosition):
		figurePosition = newPosition
		view.update_Figure_View_Pos()

func move_Right():
	var newPosition = figurePosition
	newPosition.x += 1
	if is_Allowed(figure, newPosition):
		figurePosition = newPosition
		view.update_Figure_View_Pos()

func move_Down():
	var newPosition = figurePosition
	newPosition.y += 1
	if is_Allowed(figure, newPosition):
		figurePosition = newPosition
		view.update_Figure_View_Pos()
	else:
		stop_Figure()

func do_Rotation():
	var newFigure = rotate_Figure()
	if is_Allowed(newFigure, figurePosition):
		figure = newFigure
		view.update_Figure_View()

func stop_Figure():
	for y in figure.size():
		for x in figure[y].size():
			if figure[y][x] == 1:
				field[figurePosition.y + y][figurePosition.x + x] = 1
	view.update_Field_View()
	new_Figure()
	remove_Lines()

func remove_Lines():
	var removedLines = []
	for y in field.size():
		var fullLine = true
		for x in field[y].size():
			if field[y][x] == 0:
				fullLine = false
				break
		if fullLine:
			remove_Line(y)
			removedLines.append(y)
	removedLines.invert()
	view.remove_Lines(removedLines)

func remove_Line(lineNumber):
	for y in range(lineNumber, 1, -1):
		for x in field[y].size():
			field[y][x] = field[y - 1][x]

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

func rotate_Figure():
	var newFigure = []
	newFigure.resize(figure[0].size())
	for y in newFigure.size():
		newFigure[y] = []
		newFigure[y].resize(figure.size())
		for x in newFigure[y].size():
			newFigure[y][x] = figure[x][figure[0].size() - y - 1]
	return newFigure
