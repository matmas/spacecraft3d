@tool
extends Control
class_name KeyIconRect

func get_class_name() -> StringName: return &"KeyIconRect"

const THEME = preload("key_icon_theme.tres")

@export_multiline var text := " ":
	set(value):
		text = value
		queue_redraw()

enum HorizontalAlignment { LEFT, CENTER, RIGHT }
@export var horizontal_alignment := HorizontalAlignment.CENTER:
	set(value):
		horizontal_alignment = value
		queue_redraw()

enum VerticalAlignment { TOP, CENTER, BOTTOM }
@export var vertical_alignment := VerticalAlignment.CENTER:
	set(value):
		vertical_alignment = value
		queue_redraw()

@export var add_margin := true:
	set(value):
		add_margin = value
		queue_redraw()

@export var margin_proportion := 0.28:
	set(value):
		margin_proportion = value
		queue_redraw()

@export var allow_text_to_affect_margin := true:
	set(value):
		allow_text_to_affect_margin = value
		queue_redraw()

func _init() -> void:
	theme = THEME


func _get_height() -> int:
	return int(size.y)

#
func _get_width() -> int:
	return int(size.x)


func _draw() -> void:
	if not text:
		return

	# Determine text dimensions
	var font := get_theme_font(&"font", get_class_name())
	var test_font_size := 16  # font_size will be calculated dynamically later
	var test_text_dimensions := font.get_multiline_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, test_font_size)

	# Calculate key size
	var rect := Rect2(0, 0, _get_width(), _get_height())
	var x_ratio := clampf(test_text_dimensions.aspect(), 1.0, 10.0) if allow_text_to_affect_margin else 1.0
	var y_ratio := clampf(test_text_dimensions.aspect(), 1.0, 1.8) if allow_text_to_affect_margin else 1.0
	if add_margin:
		rect = rect.grow_individual(
			-rect.size.x * margin_proportion * 0.5 / x_ratio,
			-rect.size.y * margin_proportion * 0.5 * y_ratio,
			-rect.size.x * margin_proportion * 0.5 / x_ratio,
			-rect.size.y * margin_proportion * 0.5 * y_ratio,
		)

	#if maxf(test_text_dimensions.x, test_text_dimensions.y) == 23:
		#rect = Rect2(14, 14, _get_width() - 2 * 14, _get_height() - 2 * 14)

	# Draw outline
	var outline_stylebox := get_theme_stylebox(&"outline", get_class_name()) as StyleBoxFlat
	draw_style_box(outline_stylebox, rect)

	# Draw keycap
	rect = Rect2(rect.position + Vector2(
		outline_stylebox.content_margin_left,
		outline_stylebox.content_margin_top
	), rect.size - Vector2(
		outline_stylebox.content_margin_left + outline_stylebox.content_margin_right,
		outline_stylebox.content_margin_top + outline_stylebox.content_margin_bottom)
	)
	var keycap_stylebox := get_theme_stylebox(&"keycap", get_class_name()) as StyleBoxFlat
	draw_style_box(keycap_stylebox, rect)

	# Draw text string
	rect = Rect2(rect.position + Vector2(
		keycap_stylebox.content_margin_left,
		keycap_stylebox.content_margin_top
	), rect.size - Vector2(
		keycap_stylebox.content_margin_left + keycap_stylebox.content_margin_right,
		keycap_stylebox.content_margin_top + keycap_stylebox.content_margin_bottom)
	)
	var font_size := mini(
		# Using floori() ensures we can always fit the string
		floori(test_font_size / test_text_dimensions.x * rect.size.x),
		floori(test_font_size / test_text_dimensions.y * rect.size.y),
	)
	# Align text vertically
	var text_dimensions := font.get_multiline_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	if text_dimensions.aspect() / rect.size.aspect() > 1:
		var shrink_amount := rect.size.y - text_dimensions.y
		match vertical_alignment:
			VerticalAlignment.TOP:
				rect = rect.grow_individual(0, 0, 0, -shrink_amount)
			VerticalAlignment.CENTER:
				rect = rect.grow_individual(0, -shrink_amount * 0.5, 0, -shrink_amount * 0.5)
			VerticalAlignment.BOTTOM:
				rect = rect.grow_individual(0, -shrink_amount, 0, 0)

	draw_multiline_string(
		font,
		rect.position + Vector2(0, font.get_ascent(font_size)),
		text,
		int(horizontal_alignment),
		rect.size.x,
		font_size,
		-1,
		get_theme_color("font_color", get_class_name())
	)
