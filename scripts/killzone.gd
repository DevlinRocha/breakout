extends Area2D


signal lost_life


func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D):
	if body is Ball:
		body.queue_free()
		lost_life.emit()
