extends CanvasLayer

var is_open = false

@onready var input_field = $Panel/SubViewportContainer/SubViewport/InputRow/InputField
@onready var beep = $BeepPlayer
@onready var blip = $BeepPlayer2

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func open():
	$Panel/SubViewportContainer/SubViewport.update_quota()
	beep.play(0.4)
	visible = true
	is_open = true
	get_tree().paused = true
	input_field.editable = true
	$Panel/SubViewportContainer/SubViewport/Node2D.process_mode = Node.PROCESS_MODE_ALWAYS
	input_field.grab_focus()

func close():
	beep.play(0.4)
	visible = false
	is_open = false
	get_tree().paused = false
	input_field.editable = false
	input_field.release_focus()

func play_blip():
	blip.play(0.4)
