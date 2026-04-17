extends CanvasLayer

signal fade_done

func fade_in():
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished
	emit_signal("fade_done")

func fade_out():
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	emit_signal("fade_done")

func transition_to(scene_path: String):
	fade_out()
	await fade_done
	get_tree().change_scene_to_file(scene_path)
	fade_in()
