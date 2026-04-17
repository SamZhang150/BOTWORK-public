extends Node2D

func _ready():
	visible = false
	$AnimationPlayer.play("bob")

func show_indicator():
	visible = true

func hide_indicator():
	visible = false
