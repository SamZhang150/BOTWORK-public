extends CharacterBody2D

@onready var power_on = $PowerOnPlayer
@onready var ambient = $AmbientPlayer

const SPEED = 400.0

func _ready():
	await get_tree().create_timer(4.6).timeout
	power_on.finished.connect(_on_poweron_finished)
	power_on.play()

func _on_poweron_finished():
	ambient.play()

func _physics_process(delta):
	
	if $AnimatedSprite2D.animation == "waken":
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play("idle")
	else:
		var direction = Vector2.ZERO

		direction.x = Input.get_axis("ui_left", "ui_right")
		direction.y = Input.get_axis("ui_up", "ui_down")
		if direction != Vector2.ZERO:
			direction = direction.normalized()
			velocity = direction * SPEED
			$AnimatedSprite2D.play("run")
			if direction.x != 0:
				$AnimatedSprite2D.flip_h = direction.x < 0
		else:
			velocity = velocity.move_toward(Vector2.ZERO, SPEED)
			$AnimatedSprite2D.play("idle")

		move_and_slide()
