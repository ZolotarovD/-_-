extends Node2D


func _process(delta):
	if not $music.is_playing():
		$music.play()
	
	$CharacterBody2D/Label.position.y -= 60 * delta
