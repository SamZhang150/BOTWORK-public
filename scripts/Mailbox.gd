extends Area2D

signal mail_collected

@onready var print = $PrintPlayer
@onready var indicator = $InteractionIndicator

var player_nearby = false
var has_mail = false

func _ready():
	$AnimatedSprite2D.play("empty")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta):
	if player_nearby and has_mail:
		indicator.show_indicator()
		if Input.is_action_just_pressed("interact"):
			collect_mail()

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_nearby = true
		if has_mail:
			indicator.show_indicator()

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false
		indicator.hide_indicator()

var mail_texture: Texture2D

func receive_mail(texture: Texture2D):
	if player_nearby:
		indicator.show_indicator()
	if $AnimatedSprite2D.animation == "empty":
		print.play(1)
		await get_tree().create_timer(1.4).timeout
		mail_texture = texture
		has_mail = true
		$AnimatedSprite2D.play("printing")
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play("full")

func collect_mail():
	has_mail = false
	$AnimatedSprite2D.play("empty")
	emit_signal("mail_collected")
	MailViewer.show_mail(mail_texture)
	mail_texture = null
	indicator.hide_indicator()
