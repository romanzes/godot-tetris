extends ColorRect

var shiftY: int = 0
onready var tween = $Tween

func destroy():
	$AnimationPlayer.play("destroy")
