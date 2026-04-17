extends SubViewport

@onready var output = $TerminalOutput
@onready var input_field = $InputRow/InputField
@onready var audio_player = $"../../../AudioStreamPlayer"

var TRACKS = {
	"1": {"name": "Reverie", "file": preload("res://assets/audio/reverie.wav")},
}

var current_track = null

func _ready():
	input_field.editable = false
	input_field.text_submitted.connect(_on_command_entered)
	audio_player.process_mode = Node.PROCESS_MODE_ALWAYS
	print_line("Type [b]list[/b] to see available tracks.")
	print_line("Type [b]play <id>[/b] to play a track.")
	print_line("Type [b]stop[/b] to stop playback.")
	print_line("Type [b]quit[/b] to exit.")
	input_field.editable = true
	input_field.grab_focus()
	
func _process(delta):
	if SceneManager.current_level == 12:
		audio_player.stop()

func print_line(text: String):
	output.append_text("\n" + text)

func _on_command_entered(text: String):
	if SceneManager.current_level >= 5:
		TRACKS = {
			"1": {"name": "Reverie", "file": preload("res://assets/audio/reverie.wav")},
			"2": {"name": "for_cal", "file": preload("res://assets/audio/song1.wav")},
		}
	if SceneManager.current_level >= 9:
		TRACKS = {
			"1": {"name": "Reverie", "file": preload("res://assets/audio/reverie.wav")},
			"2": {"name": "for_cal", "file": preload("res://assets/audio/song1.wav")},
			"3": {"name": "kinderszenen_7", "file": preload("res://assets/audio/kinderszenen7.wav")},
		}
	var command = text.strip_edges().to_lower()
	input_field.clear()
	print_line("> " + command)

	if command.begins_with("play "):
		var id = command.substr(5).strip_edges()
		play_track(id)
		return

	match command:
		"list":
			print_line("Available tracks:")
			for id in TRACKS:
				var suffix = " ♪" if current_track == id else ""
				print_line("  [b]%s[/b] — %s%s" % [id, TRACKS[id]["name"], suffix])
		"stop":
			stop_track()
		"quit":
			quit()
		_:
			print_line("Unknown command.")

func play_track(id: String):
	if not TRACKS.has(id):
		print_line("Track '%s' not found. Type list to see available tracks." % id)
		return
	current_track = id
	audio_player.stream = TRACKS[id]["file"]
	audio_player.play()
	print("audio player playing: ", audio_player.playing)
	print("audio player stream: ", audio_player.stream)
	print("audio player volume db: ", audio_player.volume_db)
	print("audio player bus: ", audio_player.bus)
	print_line("Now playing: %s" % TRACKS[id]["name"])

func stop_track():
	if audio_player.playing:
		audio_player.stop()
		current_track = null
		print_line("Playback stopped.")
	else:
		print_line("Nothing is playing.")

func quit():
	input_field.editable = false
	output.visible = true
	MusicMenu.close()
	
func is_playing() -> bool:
	return audio_player.playing
