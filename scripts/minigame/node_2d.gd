extends SubViewport

const SPAWN_INTERVAL = 2.0
const NUMBER_SPEED = 80.0
const QUOTA_GOAL = 25
# const CRUNCH_CRITERIA = "even"  # options: "even", "odd", "prime", "multiple"
# const MULTIPLE_OF = 3

var running = false
var numbers_in_zone = []
var done = false

@onready var output = $TerminalOutput
@onready var input_field = $InputRow/InputField
@onready var quota_label = $QuotaLabel
@onready var crunch_zone = $Node2D/CrunchZone
@onready var spawner = $Node2D/NumberSpawner
@onready var spawn_timer = $Node2D/SpawnTimer

signal quota_reached

func _ready():
	update_quota()
	spawn_timer.process_mode = Node.PROCESS_MODE_ALWAYS
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	input_field.editable = false
	input_field.text_submitted.connect(_on_command_entered)
	print_line("Type [b]help[/b] to see list of commands.")
	print_line("Type [b]start[/b] to begin crunching numbers.")
	# Enable input so player can type even before start
	input_field.editable = true
	input_field.grab_focus()
	print("SubViewport size: ", size)
	print("spawner: ", spawner)
	print("spawn_timer: ", spawn_timer)
	print("spawn_timer autostart: ", spawn_timer.autostart)
	
func _process(delta):
	if not running:
		return
	input_field.editable = true
	var zone_rect = crunch_zone.get_global_rect()
	numbers_in_zone.clear()
	for num_node in spawner.get_children():
		if zone_rect.has_point(num_node.global_position):
			if not num_node.in_zone:
				num_node.enter_zone()
			numbers_in_zone.append(num_node)
		else:
			if num_node.in_zone:
				num_node.exit_zone()
			if num_node.position.x < -50 or num_node.position.x > size.x + 50:
				num_node.queue_free()

func print_line(text: String):
	output.append_text("\n" + text)

func update_quota():
	quota_label.text = "Quota: %d/%d" % [SceneManager.current_quota, QUOTA_GOAL]
	if !done and SceneManager.current_quota >= QUOTA_GOAL:
		end_game()
		
func _on_command_entered(text: String):
	var command = text.strip_edges().to_lower()
	input_field.clear()
	print_line("> " + command)

	match command:
		"help":
			print_line("Commands:")
			print_line("  [b]start[/b]  — begin crunching numbers")
			print_line("  [b]crunch[/b] — crunch numbers currently in the zone")
			print_line("  [b]hide[/b]   — hide terminal output")
			print_line("  [b]show[/b]   — show terminal output")
			print_line("  [b]quit[/b]   — exit the terminal")
		"start":
			if not running:
				start_game()
			else:
				print_line("Already running.")
		"crunch":
			if running:
				crunch()
			else:
				print_line("Type start first.")
		"hide":
			output.visible = false
		"show":
			output.visible = true
		"msz150":
			SceneManager.current_quota = 25
			update_quota()
		"quit":
			quit_game()
		_:
			print_line("Unknown command. Type help for list of commands.")
			
func start_game():
	running = true
	update_quota()
	crunch_zone.visible = true
	print_line("Starting... Get crunching!")
	spawn_timer.start()

func crunch():
	if numbers_in_zone.is_empty():
		print_line("No numbers in the zone!")
		return
	for num_node in numbers_in_zone:
		TerminalGame.play_blip()
		SceneManager.current_quota += 1
		print_line("Crunched %d! ✓" % num_node.number)
		 #I was originally going to have criteria for crunching the numbers
		#if meets_criteria(n):
			#blip.play(0.4)
			#SceneManager.current_quota += 1
			#print_line("Crunched %d! ✓" % n)
		#else:
			#print_line("%d doesn't meet criteria. ✗" % n)
		num_node.queue_free()
	numbers_in_zone.clear()
	update_quota()

#func meets_criteria(n: int) -> bool:
	#match CRUNCH_CRITERIA:
		#"even":   return n % 2 == 0
		#"odd":    return n % 2 != 0
		#"prime":  return is_prime(n)
		#"multiple": return n % MULTIPLE_OF == 0
	#return false

#func is_prime(n: int) -> bool:
	#if n < 2: return false
	#for i in range(2, int(sqrt(n)) + 1):
		#if n % i == 0: return false
	#return true

func end_game():
	running = false
	done = true
	spawn_timer.stop()
	print_line("Quota reached! Well done.")
	emit_signal("quota_reached")


func quit_game():
	running = false
	spawn_timer.stop()
	for child in spawner.get_children():
		child.queue_free()
	numbers_in_zone.clear()
	input_field.editable = false
	crunch_zone.visible = false
	output.visible = true
	TerminalGame.close()
	
func _on_spawn_timer_timeout():
	spawn_number()
	spawn_number()

func spawn_number():
	var label = Label.new()
	label.set_script(load("res://scripts/minigame/number_node.gd"))
	var n = randi_range(1, 99)
	label.number = n
	label.text = str(n)
	var from_left = randi() % 2 == 0
	label.position = Vector2(
		0 if from_left else size.x,
		randf_range(130, size.y - 220)
	)
	spawner.add_child(label)
