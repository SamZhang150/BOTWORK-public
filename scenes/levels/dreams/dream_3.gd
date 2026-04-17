extends Node2D

var mail_collected = 0
var mail_queue = [
	["mail7a", 10.0],
	["mail7b", 10.0],
	["mail7c", 10.0]
]

func _ready():
	$Mailbox.mail_collected.connect(_on_mail_collected)
	process_mail_queue()

func process_mail_queue():
	if mail_queue.is_empty():
		return
	var next = mail_queue.pop_front()
	await get_tree().create_timer(next[1], false).timeout
	$Mailbox.receive_mail(SceneManager.MAIL[next[0]])


func _on_mail_collected():
	mail_collected += 1
	if MailViewer.is_open:
		await MailViewer.mail_closed
	process_mail_queue()
	if mail_collected == 3:
		await get_tree().create_timer(15).timeout
		SceneManager.advance_level()
