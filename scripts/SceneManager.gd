extends Node

const MAIL = {
	"mail1a": preload("res://assets/sprites/mail/mail1a.png"),
	"mail1b": preload("res://assets/sprites/mail/mail1b.png"),
	"mail2a": preload("res://assets/sprites/mail/mail2a.png"),
	"mail2b": preload("res://assets/sprites/mail/mail2b.png"),
	"mail2c": preload("res://assets/sprites/mail/mail2c.png"),
	"mail2d": preload("res://assets/sprites/mail/mail2d.png"),
	"mail2e": preload("res://assets/sprites/mail/mail2e.png"),
	"mail3a": preload("res://assets/sprites/mail/mail3a.png"),
	"mail3b": preload("res://assets/sprites/mail/mail3b.png"),
	"mail3c": preload("res://assets/sprites/mail/mail3c.png"),
	"mail3d": preload("res://assets/sprites/mail/mail3d.png"),
	"mail4a": preload("res://assets/sprites/mail/mail4a.png"),
	"mail4b": preload("res://assets/sprites/mail/mail4b.png"),
	"mail4c": preload("res://assets/sprites/mail/mail4c.png"),
	"mail4d": preload("res://assets/sprites/mail/mail4d.png"),
	"mail4e": preload("res://assets/sprites/mail/mail4e.png"),
	"mail5a": preload("res://assets/sprites/mail/mail5a.png"),
	"mail5b": preload("res://assets/sprites/mail/mail5b.png"),
	"mail5c": preload("res://assets/sprites/mail/mail5c.png"),
	"mail6a": preload("res://assets/sprites/mail/mail6a.png"),
	"mail6b": preload("res://assets/sprites/mail/mail6b.png"),
	"mail6c": preload("res://assets/sprites/mail/mail6c.png"),
	"mail6d": preload("res://assets/sprites/mail/mail6d.png"),
	"mail7a": preload("res://assets/sprites/mail/mail7a.png"),
	"mail7b": preload("res://assets/sprites/mail/mail7b.png"),
	"mail7c": preload("res://assets/sprites/mail/mail7c.png"),
	"mail8a": preload("res://assets/sprites/mail/mail8a.png"),
	"mail8b": preload("res://assets/sprites/mail/mail8b.png"),
	"mail8c": preload("res://assets/sprites/mail/mail8c.png"),
	"mail8d": preload("res://assets/sprites/mail/mail8d.png"),
	"mail8e": preload("res://assets/sprites/mail/mail8e.png"),
	"mail8f": preload("res://assets/sprites/mail/mail8f.png"),
	"mail8g": preload("res://assets/sprites/mail/mail8g.png"),
	"mail8h": preload("res://assets/sprites/mail/mail8h.png"),
	"mail9a": preload("res://assets/sprites/mail/mail9a.png"),
	"mail9b": preload("res://assets/sprites/mail/mail9b.png"),
	"mail9c": preload("res://assets/sprites/mail/mail9c.png"),
	"mail9d": preload("res://assets/sprites/mail/mail9d.png"),
	"mail9e": preload("res://assets/sprites/mail/mail9e.png"),
	"mail10a": preload("res://assets/sprites/mail/mail10a.png"),
	"mail10b": preload("res://assets/sprites/mail/mail10b.png"),
	"mail10c": preload("res://assets/sprites/mail/mail10c.png"),
	"mail11a": preload("res://assets/sprites/mail/mail11a.png"),
	"mail11b": preload("res://assets/sprites/mail/mail11b.png"),
	"mail11c": preload("res://assets/sprites/mail/mail11c.png"),
	"mail12c": preload("res://assets/sprites/mail/mail12c.png"),
}

const LEVELS = [
	"res://scenes/levels/days/day1.tscn",
	"res://scenes/levels/days/day2.tscn",
	"res://scenes/levels/dreams/dream1.tscn",
	"res://scenes/levels/days/day3.tscn",
	"res://scenes/levels/dreams/dream2.tscn",
	"res://scenes/levels/days/day4.tscn",
	"res://scenes/levels/dreams/dream3.tscn",
	"res://scenes/levels/days/day5.tscn",
	"res://scenes/levels/dreams/dream4.tscn",
	"res://scenes/levels/days/day6.tscn",
	"res://scenes/levels/dreams/dream5.tscn",
	"res://scenes/levels/days/day7.tscn",
]

var current_level = 0
var current_quota = 0

func advance_level():
	current_level += 1
	current_quota = 0
	TerminalGame.get_node("Panel/SubViewportContainer/SubViewport").done = false
	if current_level < LEVELS.size():
		Fade.transition_to(LEVELS[current_level])
	else:
		Fade.transition_to("res://scenes/levels/ending.tscn")

func is_dream():
	return LEVELS[current_level].contains("dream")
