extends PanelContainer


signal game_restart


@onready var current_score: Label = %CurrentScore
@onready var high_score: Label = %HighScore
@onready var restart: Button = %Restart
@onready var quit: Button = %Quit


func _ready() -> void:
	if not restart.pressed.is_connected(_on_restart_pressed):
		restart.pressed.connect(_on_restart_pressed)
	if not quit.pressed.is_connected(_on_quit_pressed):
		quit.pressed.connect(_on_quit_pressed)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		visible = true if visible == false else false

		get_tree().paused = true if visible == true else false



func _on_restart_pressed() -> void:
	game_restart.emit()


func _on_quit_pressed() -> void:
	get_tree().quit()


func update_current_score(new_score: int) -> void:
	current_score.text = "Current score: " + str(new_score)


func update_high_score(new_high_score: int) -> void:
	high_score.text = "High score: " + str(new_high_score)
