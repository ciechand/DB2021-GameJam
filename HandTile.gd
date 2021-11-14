extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tileNum = 0
var destroy = false
onready var Tween = get_node("Tween")

# Called when the node enters the scene tree for the first time.
func _ready():
	region_rect.position.x = tileNum*20
	#$AnimationPlayer.stop()
	#Tween.interpolate_property(self, "scale", Vector2(1, 1),Vector2(1,0), 1)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func showHand():
	Tween.interpolate_property(self, "scale", Vector2(0.8, 0),Vector2(1,1), 0.3)
	Tween.interpolate_property(get_parent(), "position", Vector2(113,970), get_parent().position, 0.3)
	Tween.start()
	pass

func hideHand():
	$AnimationPlayer.stop()
	Tween.interpolate_property(self, "scale", Vector2(1, 1),Vector2(0.8,0), 0.3)
	Tween.interpolate_property(get_parent(), "position", get_parent().position,Vector2(113,970), 0.3)
	Tween.start()
	destroy = true
	pass

func _on_Tween_tween_completed(object, key):
	if destroy:
		get_parent().queue_free()
	else:
		$AnimationPlayer.play()
	pass # Replace with function body.
