extends CharacterBody2D


@export var Player: Type


enum Type {player1, player2}
const SPEED = 320


func _process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		position.x -= SPEED * delta
	if Input.is_action_pressed("right"):
		position.x += SPEED * delta
	move_and_slide()
