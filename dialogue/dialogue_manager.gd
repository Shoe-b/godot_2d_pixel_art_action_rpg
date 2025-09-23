extends Node

signal dialogue_started
signal dialogue_ended

var current_dialogue: Array = []
var current_line: int = 0
var is_dialogue_active: bool = false
var dialogue_paused: bool = false

# References to players
var player1: Node2D
var player2: Node2D

# Floating bubble scene
var floating_bubble_scene = preload("res://dialogue/floating_speech_bubble.tscn")

# Sample dialogue data (adjusted for retro pixel style)
var dialogues = {
	"meeting_spot": [
		{"speaker": "Player 1", "text": "Hey... can I tell you something?", "player": 1},
		{"speaker": "Player 2", "text": "Of course! What's on your mind?", "player": 2},
		{"speaker": "Player 1", "text": "We've been on adventures together...", "player": 1},
		{"speaker": "Player 1", "text": "And I realized something special.", "player": 1},
		{"speaker": "Player 2", "text": "Really? What is it?", "player": 2},
		{"speaker": "Player 1", "text": "Will you be my girlfriend?", "player": 1},
		{"speaker": "Player 2", "text": "Yes! I was hoping you'd ask!", "player": 2},
		{"speaker": "Player 1", "text": "You made me so happy!", "player": 1}
	],
	"tree_chat": [
		{"speaker": "Player 2", "text": "These trees are romantic!", "player": 2},
		{"speaker": "Player 1", "text": "Like us! Let's carve initials.", "player": 1},
		{"speaker": "Player 2", "text": "P1 + P2 forever!", "player": 2},
		{"speaker": "Player 1", "text": "Forever and always!", "player": 1}
	],
	"bush_area": [
		{"speaker": "Player 1", "text": "Even if we get lost...", "player": 1},
		{"speaker": "Player 2", "text": "We're together, I'm not afraid.", "player": 2},
		{"speaker": "Player 1", "text": "That's why I love you.", "player": 1},
		{"speaker": "Player 2", "text": "I love you too!", "player": 2}
	]
}

func _ready():
	# Find the players in the scene
	player1 = get_node("../Player") if has_node("../Player") else null
	player2 = get_node("../Player2") if has_node("../Player2") else null
	
	print("DialogueManager ready - Player1: ", player1, " Player2: ", player2)
	
	if not player1 or not player2:
		print("Warning: Could not find both players!")
		# Try alternative paths
		player1 = get_node("/root/World/Player") if has_node("/root/World/Player") else null
		player2 = get_node("/root/World/Player2") if has_node("/root/World/Player2") else null
		print("Alternative search - Player1: ", player1, " Player2: ", player2)

func start_dialogue(dialogue_key: String):
	print("Starting dialogue: ", dialogue_key)
	if is_dialogue_active or not dialogues.has(dialogue_key):
		print("Dialogue blocked - active: ", is_dialogue_active, " has key: ", dialogues.has(dialogue_key))
		return
	
	current_dialogue = dialogues[dialogue_key]
	current_line = 0
	is_dialogue_active = true
	dialogue_paused = false
	
	print("Found ", current_dialogue.size(), " dialogue lines")
	
	# Don't pause the game for floating bubbles - let players move around
	
	show_current_line()
	dialogue_started.emit()

func show_current_line():
	if current_line >= current_dialogue.size():
		end_dialogue()
		return
	
	var line = current_dialogue[current_line]
	var target_player = player1 if line.player == 1 else player2
	
	if target_player:
		spawn_floating_bubble(target_player, line.text, line.player)
	
	# Auto-advance to next line after a shorter delay for smaller bubbles
	await get_tree().create_timer(2.0).timeout
	
	if is_dialogue_active and not dialogue_paused:
		next_line()

func spawn_floating_bubble(target_player: Node2D, text: String, player_num: int):
	print("Spawning bubble for player ", player_num, " with text: ", text)
	print("Target player position: ", target_player.global_position)
	
	var bubble = floating_bubble_scene.instantiate()
	get_parent().add_child(bubble)
	
	# Position bubble above the player (closer since bubbles are smaller)
	bubble.global_position = target_player.global_position + Vector2(0, -35)
	print("Bubble positioned at: ", bubble.global_position)
	
	# Set bubble type based on player
	var bubble_type = "player1" if player_num == 1 else "player2"
	bubble.setup_bubble(text, bubble_type)
	print("Bubble setup complete")

func next_line():
	if not is_dialogue_active:
		return
	
	current_line += 1
	show_current_line()

func end_dialogue():
	is_dialogue_active = false
	current_dialogue.clear()
	current_line = 0
	dialogue_paused = false
	
	dialogue_ended.emit()

func pause_dialogue():
	dialogue_paused = true

func resume_dialogue():
	dialogue_paused = false
	if is_dialogue_active:
		show_current_line()

func _input(event):
	# Optional: Allow players to advance dialogue manually with spacebar
	if is_dialogue_active and event.is_action_pressed("ui_accept"):
		next_line()
