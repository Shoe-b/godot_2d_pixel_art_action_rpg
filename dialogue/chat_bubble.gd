extends Control

@onready var speaker_label: Label = $BubbleContainer/SpeakerLabel
@onready var text_label: Label = $BubbleContainer/TextLabel
@onready var bubble_bg: Panel = $BubbleContainer/BubbleBackground

func setup_bubble(speaker: String, text: String, side: String = "left"):
	speaker_label.text = speaker
	text_label.text = text
	
	# Create style boxes for different sides
	var style_box = StyleBoxFlat.new()
	
	if side == "right":
		# Right side (Player 2) - Pink bubble
		anchor_left = 0.3
		anchor_right = 1.0
		$BubbleContainer.alignment = BoxContainer.ALIGNMENT_END
		speaker_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		
		# Pink style
		style_box.bg_color = Color(0.9, 0.4, 0.7, 0.9)
		style_box.border_color = Color(1.0, 0.6, 0.8, 1.0)
		style_box.corner_radius_top_left = 15
		style_box.corner_radius_top_right = 15
		style_box.corner_radius_bottom_right = 5
		style_box.corner_radius_bottom_left = 15
		
		speaker_label.modulate = Color(1.0, 1.0, 1.0, 1.0)
		text_label.modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		# Left side (Player 1) - Blue bubble
		anchor_left = 0.0
		anchor_right = 0.7
		$BubbleContainer.alignment = BoxContainer.ALIGNMENT_BEGIN
		speaker_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		
		# Blue style
		style_box.bg_color = Color(0.3, 0.5, 0.9, 0.9)
		style_box.border_color = Color(0.5, 0.7, 1.0, 1.0)
		style_box.corner_radius_top_left = 15
		style_box.corner_radius_top_right = 15
		style_box.corner_radius_bottom_right = 15
		style_box.corner_radius_bottom_left = 5
		
		speaker_label.modulate = Color(1.0, 1.0, 1.0, 1.0)
		text_label.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	# Apply border styling
	style_box.border_width_left = 2
	style_box.border_width_top = 2
	style_box.border_width_right = 2
	style_box.border_width_bottom = 2
	
	bubble_bg.add_theme_stylebox_override("panel", style_box)
	
	# Animate the bubble appearing
	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.3)
