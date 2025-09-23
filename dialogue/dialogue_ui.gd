extends Control

@onready var chat_container: VBoxContainer = $ChatContainer
@onready var continue_label: Label = $ContinueLabel

var bubble_scene = preload("res://dialogue/chat_bubble.tscn")

func _ready():
	hide()

func update_dialogue(speaker: String, text: String, side: String = "left"):
	# Create new chat bubble
	var bubble = bubble_scene.instantiate()
	chat_container.add_child(bubble)
	bubble.setup_bubble(speaker, text, side)
	
	# Scroll to bottom
	await get_tree().process_frame
	if chat_container.get_child_count() > 5:
		# Remove old bubbles to prevent overflow
		chat_container.get_child(0).queue_free()

func clear_chat():
	for child in chat_container.get_children():
		child.queue_free()

func _on_continue_pressed():
	# Get dialogue manager and advance to next line
	var dialogue_manager = get_node("../../DialogueManager")
	if dialogue_manager:
		dialogue_manager.next_line()

func _input(event):
	if visible and (event.is_action_pressed("ui_accept") or event.is_action_pressed("attack") or event.is_action_pressed("p2_attack")):
		_on_continue_pressed()
