extends Area2D

signal terminal_started

@onready var indicator = $InteractionIndicator
@onready var sprite = $AnimatedSprite2D
@onready var sub_viewport = MusicMenu.get_node("Panel/SubViewportContainer/SubViewport")

var player_nearby = false
var active = false
var interactable = true

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
	if !interactable:
		await get_tree().create_timer(0.5).timeout
		$AnimatedSprite2D.play("off")
	else:
		await get_tree().create_timer(0.5).timeout
		$AnimatedSprite2D.play("idle")
	if player_nearby and Input.is_action_just_pressed("interact"):
		if active and interactable:
			open_music()
			
	if active:
		if sub_viewport.is_playing():
			sprite.play("idle")
		else:
			sprite.play("off")

func activate():
	$AnimatedSprite2D.visible = true
	active = true
	
func set_interactable():
	interactable = true

func open_music():
	MusicMenu.open()
