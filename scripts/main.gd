extends Node


@onready var bricks: Node = %Bricks
@onready var score: Label = %Score
@onready var life_counter: VBoxContainer = %LifeCounter
@onready var killzone: Area2D = $Killzone
@onready var pause_menu: PanelContainer = %PauseMenu
@onready var game_over_screen: Label = %GameOver

func _ready() -> void:
	load_score()
	if not killzone.lost_life.is_connected(_on_lost_life):
		killzone.lost_life.connect(_on_lost_life)
	if not pause_menu.game_restart.is_connected(restart):
		pause_menu.game_restart.connect(restart)
	restart()


func start_game() -> void:
	game_over_screen.visible = false
	for child in get_children():
		if child is Ball:
			child.queue_free()
	pause_menu.visible = false
	get_tree().paused = false
	const BALL := preload("res://scenes/ball.tscn")
	var new_ball = BALL.instantiate()
	if not new_ball.player_scored.is_connected(_on_player_scored):
		new_ball.player_scored.connect(_on_player_scored)

	add_child(new_ball)
	new_ball.respawn()
	new_ball.move()


func _on_lost_life() -> void:
	if life_counter.get_child_count() <= 0:
		return game_over()

	life_counter.get_child(0).queue_free()
	if life_counter.get_child_count() <= 0:
		return game_over()

	get_tree().create_timer(3).timeout.connect(start_game)


func _on_player_scored() -> void:
	var new_score := int(score.text)
	score.text = str(new_score + 1)
	pause_menu.update_current_score(new_score + 1)


func game_over() -> void:
	save_score()
	load_score()
	game_over_screen.visible = true


func restart() -> void:
	score.text = "0"
	if life_counter.get_child_count() > 0:
		for life in life_counter.get_children():
			life.queue_free()

	for brick in bricks.get_children():
		if brick is Brick:
			brick.queue_free()

	const BRICK := preload("res://scenes/brick.tscn")
	const COLORS: Array[Color] = [Color.RED, Color.RED, Color.ORANGE, Color.ORANGE, Color.GREEN, Color.GREEN, Color.YELLOW, Color.YELLOW]

	for i in 8:
		var x := 48
		var y := 16 + (36 * i)
		var color := COLORS[i]
		for j in 16:
			var brick := BRICK.instantiate()
			x = 48 + (70 * j)
		
			brick.position = Vector2(x, y)
			brick.modulate = color
			bricks.add_child(brick)

	$Player.position = Vector2(576, 576)
	create_life(3)
	start_game()


func create_life(number := 1) -> void:
	const CIRCLE := preload("res://assets/circle.png")
	var life := TextureRect.new()
	life.texture = CIRCLE
	life.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	life.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	life.custom_minimum_size = Vector2(8, 8)
	life_counter.add_child(life)
	if number > 1:
		for i in number - 1:
			var new_life := life.duplicate()
			life_counter.add_child(new_life)


func save_score() -> void:
	var final_score := score.text
	var save_file := FileAccess.open("user://savegame.save", FileAccess.READ_WRITE)
	var high_score := save_file.get_as_text()
	if int(high_score) >= int(final_score):
		return

	save_file.store_line(final_score)


func load_score() -> void:
	if not FileAccess.file_exists("user://savegame.save"):
		return

	var save_file := FileAccess.open("user://savegame.save", FileAccess.READ)
	pause_menu.update_high_score(int(save_file.get_as_text()))
