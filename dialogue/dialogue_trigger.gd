extends Area2D

@export var dialogue_key: String = "meeting_spot"
@export var trigger_once: bool = false
@export var show_hint: bool = true

var players_in_area: Array = []
var dialogue_manager: Node
var has_triggered: bool = false
var hint_label: Label

signal both_players_entered
signal player_left

func _ready():
	# Connect area signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Find dialogue manager
	dialogue_manager = get_node("/root/World/DialogueManager") if has_node("/root/World/DialogueManager") else null
	if not dialogue_manager:
		dialogue_manager = get_node("../../DialogueManager") if has_node("../../DialogueManager") else null
	
	# Create hint label if enabled
	if show_hint:
		create_hint_label()

func create_hint_label():
	hint_label = Label.new()
	hint_label.text = "💕 Chat Zone 💕"
	hint_label.modulate = Color(1, 0.8, 0.9, 0.8)
	hint_label.position = Vector2(-30, -40)
	hint_label.add_theme_font_size_override("font_size", 10)
	add_child(hint_label)
	
	# Add a gentle pulsing animation
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(hint_label, "modulate:a", 0.4, 1.0)
	tween.tween_property(hint_label, "modulate:a", 0.8, 1.0)

func _on_body_entered(body):
	# Check if it's a player
	if body.name == "Player" or body.name == "Player2":
		if body not in players_in_area:
			players_in_area.append(body)
		
		# Check if both players are in area
		if players_in_area.size() >= 2 and not has_triggered:
			trigger_dialogue()

func _on_body_exited(body):
	# Remove player from area
	if body in players_in_area:
		players_in_area.erase(body)
	
	player_left.emit()

func trigger_dialogue():
	if trigger_once and has_triggered:
		return
	
	if dialogue_manager and dialogue_key != "":
		dialogue_manager.start_dialogue(dialogue_key)
		has_triggered = true
		both_players_entered.emit()
		
		# Hide hint when dialogue starts
		if hint_label:
			hint_label.text = "💖 Conversation in progress... 💖"

func reset_trigger():
	has_triggered = false
	if hint_label:
		hint_label.text = "💕 Chat Zone 💕"
