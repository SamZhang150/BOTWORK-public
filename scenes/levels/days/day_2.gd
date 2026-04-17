extends Node2D

var mail_collected = 0
var mail_queue = [
	["mail2a", 7.0],
	["mail2b", 4.0],
]

var mail_queue2 = [
	["mail2c", 7.0],
	["mail2d", 4.0],
	["mail2e", 5.0],
]

var quota_met = false

func _ready():
	$Standby.activate()
	$Terminal.activate()
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
	if quota_met:
		process_mail_queue2()
	else:
		process_mail_queue()
	if mail_collected == 2:
		$Terminal.set_interactable()
	if mail_collected == 5:
		$Standby.allow_sleep()

func _on_quota_reached():
	print("quota reached")
	process_mail_queue2()
	quota_met = true
