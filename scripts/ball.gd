class_name Ball
extends RigidBody2D


signal player_scored


func _ready() -> void:
	max_contacts_reported = 2


func move() -> void:
	var speed := randi_range(240, 400)
	var x: int = [-1, 1].pick_random()

	linear_velocity = Vector2(x * speed, -1 * speed)


func respawn() -> void:
	global_position = Vector2(576, 560)
	linear_velocity = Vector2(0, 0)


func _on_body_entered(body: Node) -> void:
	if body is Brick:
		body.queue_free()
		player_scored.emit()
		linear_velocity *= 1.01
