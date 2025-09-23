extends Node2D

@onready var bubble_background: Panel = $BubbleBackground
@onready var text_label: Label = $BubbleBackground/MarginContainer/TextLabel
@onready var tail: Polygon2D = $BubbleTail

var display_time: float = 2.0
var fade_time: float = 0.3

func setup_bubble(text: String, bubble_type: String = "normal"):
	print("Setting up bubble with text: ", text, " type: ", bubble_type)
	text_label.text = text.to_upper()  # Convert to uppercase for retro feel
	
	# Create pixel-art style StyleBox
	var style_box = StyleBoxFlat.new()
	
	# Black background with sharp edges (no anti-aliasing)
	style_box.bg_color = Color(0, 0, 0, 1)
	style_box.border_width_left = 1
	style_box.border_width_top = 1
	style_box.border_width_right = 1
	style_box.border_width_bottom = 1
	style_box.border_color = Color(0.3, 0.3, 0.3, 1)
	
	# Sharp corners for pixel-art look
	style_box.corner_radius_top_left = 0
	style_box.corner_radius_top_right = 0
	style_box.corner_radius_bottom_right = 0
	style_box.corner_radius_bottom_left = 0
	style_box.anti_aliasing = false
	
	# Set bubble colors based on player (keeping the retro black style)
	match bubble_type:
		"player1":
			# Black bubble with blue tint for Player 1
			style_box.bg_color = Color(0, 0, 0.1, 1)
			style_box.border_color = Color(0.2, 0.3, 0.5, 1)
			tail.color = Color(0, 0, 0.1, 1)
			print("Applied player1 (dark blue) styling")
		"player2":
			# Black bubble with pink tint for Player 2
			style_box.bg_color = Color(0.1, 0, 0.05, 1)
			style_box.border_color = Color(0.4, 0.2, 0.3, 1)
			tail.color = Color(0.1, 0, 0.05, 1)
			print("Applied player2 (dark pink) styling")
		_:
			# Pure black bubble
			style_box.bg_color = Color(0, 0, 0, 1)
			style_box.border_color = Color(0.3, 0.3, 0.3, 1)
			tail.color = Color(0, 0, 0, 1)
			print("Applied default black styling")
	
	# Apply the style to the background panel
	bubble_background.add_theme_stylebox_override("panel", style_box)
	print("Pixel-art StyleBox applied to background panel")
	
	# Adjust bubble size for pixel-art style (fixed, compact sizes)
	await get_tree().process_frame
	var font = text_label.get_theme_font("font")
	var font_size = text_label.get_theme_font_size("font_size")
	var text_size = font.get_string_size(text_label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	
	# Pixel-perfect sizing with minimum dimensions
	var bubble_width = max(30, min(100, text_size.x + 8))
	var bubble_height = max(15, text_size.y + 6)
	
	# Round to even numbers for pixel-perfect appearance
	bubble_width = int(bubble_width / 2) * 2
	bubble_height = int(bubble_height / 2) * 2
	
	bubble_background.size = Vector2(bubble_width, bubble_height)
	bubble_background.position = Vector2(-bubble_width / 2, -bubble_height - 8)
	
	# Position the pixel-perfect tail
	tail.position = Vector2(0, -8)
	
	# Animate appearance
	scale = Vector2.ZERO
	var tween = create_tween()
	tween.parallel().tween_property(self, "scale", Vector2.ONE, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(self, "modulate:a", 1.0, 0.2)

func start_auto_disappear():
	# Auto-disappear after display time
	await get_tree().create_timer(display_time).timeout
	disappear()

func disappear():
	var tween = create_tween()
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, fade_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(self, "modulate:a", 0.0, fade_time)
	await tween.finished
	queue_free()

func _ready():
	# Start auto-disappear timer
	start_auto_disappear()
