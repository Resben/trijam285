extends CanvasLayer
class_name UI

var money_wasted = 0

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
