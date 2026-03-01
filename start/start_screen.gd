extends CanvasLayer

@onready var video_player = $Control/VideoStreamPlayer
@onready var play_btn     = $Control/PlayButton
@onready var quit_btn     = $Control/QuitButton

func _ready():
	$Control.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# Video setup
	video_player.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	video_player.stream = load("res://start/start.ogv")
	video_player.expand = true
	video_player.play()

	# Button sizing and positioning
	var screen = get_viewport().get_visible_rect().size

	_style_button(play_btn, "PLAY")
	_style_button(quit_btn, "QUIT")

	play_btn.size = Vector2(200, 55)
	quit_btn.size = Vector2(200, 55)

	play_btn.position = Vector2((screen.x / 2) - 220, screen.y * 0.72)
	quit_btn.position = Vector2((screen.x / 2) + 20,  screen.y * 0.72)

	# Fade buttons in
	play_btn.modulate.a = 0
	quit_btn.modulate.a = 0

	await get_tree().create_timer(1.0).timeout

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(play_btn, "modulate:a", 1.0, 0.8)
	tween.tween_property(quit_btn, "modulate:a", 1.0, 0.8)

	play_btn.pressed.connect(_on_play)
	quit_btn.pressed.connect(_on_quit)

func _style_button(btn: Button, label: String):
	btn.text = label

	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.0, 0.0, 0.0, 0.75)
	style.border_color = Color(0.6, 0, 0, 1)
	style.set_border_width_all(2)
	style.set_corner_radius_all(4)
	btn.add_theme_stylebox_override("normal", style)

	var hover_style = StyleBoxFlat.new()
	hover_style.bg_color = Color(0.35, 0, 0, 0.9)
	hover_style.border_color = Color(0.9, 0, 0, 1)
	hover_style.set_border_width_all(2)
	hover_style.set_corner_radius_all(4)
	btn.add_theme_stylebox_override("hover", hover_style)

	btn.add_theme_color_override("font_color", Color(0.9, 0.9, 0.9, 1))
	btn.add_theme_font_size_override("font_size", 20)

func _on_play():
	get_tree().change_scene_to_file("res://levels/level.tscn")

func _on_quit():
	get_tree().quit()
