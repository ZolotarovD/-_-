extends Node2D

func _ready():
	$/root/HOUSE/key_main.hide()

func _process(_delta):
	if not $music.is_playing():
		$music.play()
