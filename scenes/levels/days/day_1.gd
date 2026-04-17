extends Node2D

var mail_collected = 0
var mail_queue = [
	["mail1a", 8.0],
]

func _ready():
	$Mailbox.mail_collected.connect(_on_mail_collected)
	TerminalGame.get_node("Panel/SubViewportContainer/SubViewport").quota_reached.connect(_on_quota_reached)
	process_mail_queue()

func process_mail_queue():
	if mail_queue.is_empty():
		return
	var next = mail_queue.pop_front()
	await get_tree().create_timer(next[1], false).timeout
	$Mailbox.receive_mail(SceneManager.MAIL[next[0]])
	process_mail_queue()

func _on_mail_collected():
	mail_collected += 1
	if MailViewer.is_open:
		await MailViewer.mail_closed
	match mail_collected:
		1:
			await get_tree().create_timer(1).timeout
			$Terminal.activate()
			$Terminal.set_interactable()
		2:
			await get_tree().create_timer(1).timeout
			$Standby.activate()
			$Standby.allow_sleep()

func _on_quota_reached():
	await get_tree().create_timer(5.0).timeout
	$Mailbox.receive_mail(SceneManager.MAIL["mail1b"])
