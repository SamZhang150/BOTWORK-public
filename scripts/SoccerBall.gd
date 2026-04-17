extends RigidBody2D

const KICK_FORCE = 1600.0
const KICK_RADIUS = 150.0

@onready var player = null
@onready var kick_sound = $KickSound
@onready var cooldown = $Timer

var can_play_sound = true

func _ready():
	player = get_tree().get_first_node_in_group("player")
	cooldown.timeout.connect(_on_cooldown_timeout)

func _physics_process(delta):
	if player == null:
		return
	var distance = global_position.distance_to(player.global_position)
	if distance < KICK_RADIUS:
		var direction = (global_position - player.global_position).normalized()
		apply_central_impulse(direction * KICK_FORCE)
		if can_play_sound:
			kick_sound.play(0.67)
			can_play_sound = false
			cooldown.start()

func _on_cooldown_timeout():
	can_play_sound = true
