extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -800.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 1.5

var move = "default"

const I = 2;
var inventory:Array = []
var available_thing = "";
var available_act = "";
var is_end:bool = false

const using:Dictionary = {
	"door": ["key_main", ""],
	"box": ["key_box", "key_main"]
}


func _physics_process(delta):
	if Input.is_action_just_pressed("put"):
		if is_end:
			get_tree().change_scene_to_file("res://FOREST.tscn")
		elif available_thing != "":
			$AnimatedSprite2D.play("put")
			inventory.append(available_thing)
			$/root/HOUSE.remove_child($/root/HOUSE.find_child(available_thing));
			available_thing = "";
			$/root/HOUSE/put.play()
		elif available_act != "":
			if using[available_act][0] in inventory:
				$AnimatedSprite2D.play("put")
				$/root/HOUSE.find_child(available_act).find_child("AnimatedSprite2D").play("done")
				if available_act == "door":
					is_end = true;
					$/root/HOUSE/open_door.play()
				else:
					$/root/HOUSE.find_child(using[available_act][1]).show()
					$/root/HOUSE.find_child(available_act).find_child("CollisionShape2D").hide()
					$/root/HOUSE/open_box.play()
				inventory.erase(using[available_act][0])
				available_act = "";
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("jump")
	
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if $AnimatedSprite2D.animation != "jump":
			$AnimatedSprite2D.play("walk")
			move = "walk"
		if direction == -1.0:
			$AnimatedSprite2D.flip_h = true
		elif direction == 1.0:
			$AnimatedSprite2D.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			$AnimatedSprite2D.play("default")
			move = "default"
	move_and_slide()


func _on_key_main_body_entered(body):
	if body.name == "Wendigo":
		available_thing = "key_main";
func _on_key_main_body_exited(body):
	if body.name == "Wendigo":
		available_thing = "";

func _on_key_box_body_entered(body):
	if body.name == "Wendigo":
		available_thing = "key_box";
func _on_key_box_body_exited(body):
	if body.name == "Wendigo":
		available_thing = "";

func _on_door_body_entered(body):
	if body.name == "Wendigo":
		available_act = "door";
func _on_door_body_exited(body):
	if body.name == "Wendigo":
		available_act = "";

func _on_box_body_entered(body):
	if body.name == "Wendigo":
		available_act = "box";
func _on_box_body_exited(body):
	if body.name == "Wendigo":
		available_act = "";



func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "jump":
		$AnimatedSprite2D.play(move)

