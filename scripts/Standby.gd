extends Area2D

signal sleep

@onready var indicator = $InteractionIndicator

var player_nearby = false
var active = false
var can_sleep = false

func _ready():
	$AnimatedSprite2D.visible = false
	$AnimatedSprite2D.play("inactive")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_nearby = true
		if active and can_sleep:
			indicator.show_indicator()

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false
		indicator.hide_indicator()

func _process(delta):
	if active:
		if player_nearby and Input.is_action_just_pressed("interact"):
			if active and can_sleep:
				go_to_sleep()

func activate():
	$AnimatedSprite2D.visible = true
	active = true
	$AnimatedSprite2D.play("off")

func allow_sleep():
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.play("idle")
	if player_nearby:
		indicator.show_indicator()
	can_sleep = true
	$Beep.play(0.3)

func go_to_sleep():
	emit_signal("sleep")
	can_sleep = false
	SceneManager.advance_level()
