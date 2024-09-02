extends CanvasLayer
class_name UI

var money_wasted = 0

func _ready():
	$Control/Label3.visible = false
	$Control/Label4.visible = false
	get_tree().paused = true

func add_score(score):
	money_wasted += score
	var tween = get_tree().create_tween()
	var object = $Control/Label2.duplicate() as Label
	object.text = "-$" + str(score)
	object.visible = true
	$Control.add_child(object)
	tween.tween_property(object, "position", $Control/Label.position, 1.5)
	tween.parallel().tween_property(object, "modulate", Color(1, 1, 1, 1), 1.5)
	tween.tween_callback(complete)
	tween.tween_callback(object.queue_free)

func complete():
	$Control/Label.text = "-$" + str(money_wasted)


func _on_button_pressed():
	get_tree().paused = false
	$AudioStreamPlayer.play()
	$Control/Button.visible = false

func _on_audio_stream_player_finished():
	get_tree().paused = true
	$Control/Label3.visible = true
	$Control/Label4.visible = true
	$Control/Label3.text = "Game Over"
	$Control/Label4.text = "Caused -$" + str(money_wasted) + " worth in damages goodjob!"
