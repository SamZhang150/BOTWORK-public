extends Area2D

signal terminal_started

@onready var indicator = $InteractionIndicator

var player_nearby = false
var active = false
var interactable = false

func _ready():
	$AnimatedSprite2D.visible = false
	$AnimatedSprite2D.play("inactive")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_nearby = true
		if active and interactable:
			indicator.show_indicator()

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false
		indicator.hide_indicator()

func _process(delta):
	if active and interactable and player_nearby and Input.is_action_just_pressed("interact"):
		crunch_numbers()

func activate():
	$AnimatedSprite2D.visible = true
	active = true
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.play("off")
	
func set_interactable():
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.play("idle")
	interactable = true

func crunch_numbers():
	emit_signal("terminal_started")
	TerminalGame.open()
