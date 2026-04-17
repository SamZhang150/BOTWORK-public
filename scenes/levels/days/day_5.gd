extends Node2D

var mail_collected = 0
var mail_queue = [
	["mail8a", 8.0],
	["mail8b", 4.0],
	["mail8c", 4.0],
	["mail8d", 4.0],
	["mail8e", 4.0],
	["mail8f", 4.0],
]

var mail_queue2 = [
	["mail8g", 6.0],
	["mail8h", 4.0]
]

var quota_met = false

func _ready():
	$Standby.activate()
	$Terminal.activate()
	$AudioPlayer.activate()
	$Mailbox.mail_collected.connect(_on_mail_collected)
	TerminalGame.get_node("Panel/SubViewportContainer/SubViewport").quota_reached.connect(_on_quota_reached)
	process_mail_queue()

func process_mail_queue():
	if mail_queue.is_empty():
		return
	var next = mail_queue.pop_front()
	await get_tree().create_timer(next[1], false).timeout
	$Mailbox.receive_mail(SceneManager.MAIL[next[0]])

func process_mail_queue2():
	if mail_queue2.is_empty():
		return
	var next = mail_queue2.pop_front()
	await get_tree().create_timer(next[1], false).timeout
	$Mailbox.receive_mail(SceneManager.MAIL[next[0]])

func _on_mail_collected():
	mail_collected += 1
	if MailViewer.is_open:
		await MailViewer.mail_closed
		await get_tree().create_timer(0.5).timeout
	if quota_met:
		process_mail_queue2()
	else:
		process_mail_queue()
	if mail_collected == 6:
		$Terminal.set_interactable()
	if mail_collected == 8:
		$Standby.allow_sleep()

func _on_quota_reached():
	process_mail_queue2()
	quota_met = true
