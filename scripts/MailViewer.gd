extends CanvasLayer

var is_open = false
var can_close = false

signal mail_closed

@onready var paper = $PaperPlayer

func _ready():
	$TextureRect.position.y = 1500
	$TextureRect.visible = false

func show_mail(mail_texture: Texture2D):
	paper.play()
	$TextureRect.texture = mail_texture
	$TextureRect.visible = true
	is_open = true
	can_close = false
	$AnimationPlayer.play("slide_in")
	get_tree().paused = true
	await get_tree().create_timer(1.2).timeout
	can_close = true

func close_mail():
	$AnimationPlayer.play_backwards("slide_in")
	get_tree().paused = false
	await $AnimationPlayer.animation_finished
	$TextureRect.visible = false
	is_open = false
	emit_signal("mail_closed")

func _process(delta):
	if is_open and can_close and Input.is_action_just_pressed("interact"):
		close_mail()
