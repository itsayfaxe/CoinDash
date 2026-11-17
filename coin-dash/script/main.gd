extends Node2D

const COIN_SCENE := preload('res://scenes/coin.tscn')
const ENEMY_SCENE := preload('res://scenes/enemy.tscn')

@export var coins_to_win: int = 10

var score: int = 0
var game_over: bool = false

@onready var player: CharacterBody2D = $Player
@onready var score_label: Label = $HUD/ScoreLabel
@onready var message_label: Label = $HUD/MessageLabel
@onready var game_sound: AudioStreamPlayer = $GameSound
@onready var coin_sound: AudioStreamPlayer = $CoinSound
@onready var lose_sound: AudioStreamPlayer = $LoseSound

func _ready() -> void:
	_update_score_label()
	game_sound.play()

func _on_coin_timer_timeout() -> void:
	var coin := COIN_SCENE.instantiate()
	var screen := get_viewport_rect().size
	coin.position = Vector2(randf_range(40, screen.x - 40), randf_range(40, screen.y -40))
	coin.collected.connect(_on_coin_collected)
	add_child(coin)

func _on_enemy_timer_timeout() -> void:
	var enemy := ENEMY_SCENE.instantiate()
	var screen := get_viewport_rect().size
	enemy.position = Vector2(randf_range(40, screen.x - 40), -40)
	enemy.hit_player.connect(_on_player_hit)
	add_child(enemy)

func _on_coin_collected() -> void:
	if game_over:
		return
	score += 1
	coin_sound.play()
	_update_score_label()
	if score >= coins_to_win:
		_end_game(true)
		
func _on_player_hit() -> void:
	if game_over:
		return
	lose_sound.play()
	_end_game(false)
	
func _update_score_label() -> void:
	score_label.text = 'Koin: %d / %d' % [score, coins_to_win]
	
func _end_game(won: bool) -> void:
	game_over = true
	$CoinTimer.stop()
	$EnemyTimer.stop()
	player.set_physics_process(false)
	get_tree().call_group('enemies', 'set_process', false)
	if won:
		message_label.text = 'MENANG!\nTekan Enter untuk main lagi'
	else:
		message_label.text = 'KALAH!\nTekan Enter untuk coba lagi'
	message_label.show()
		
func _unhandled_input(event: InputEvent) -> void:
	if game_over and event.is_action_pressed('ui_accept'):
		get_tree().reload_current_scene()
