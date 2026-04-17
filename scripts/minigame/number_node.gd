extends Label

var number: int = 0
var direction: Vector2 = Vector2.RIGHT
var speed: float = 0.0
var in_zone: bool = false

func _ready():
	speed = randf_range(50.0, 150.0)
	add_theme_font_size_override("font_size", randi_range(24, 48))

func _process(delta):
	position += direction * speed * delta

func enter_zone():
	in_zone = true
	add_theme_color_override("font_color", Color.GREEN)

func exit_zone():
	in_zone = false
	add_theme_color_override("font_color", Color.WHITE)
