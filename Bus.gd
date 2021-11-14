extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var moving = false
var movingQueue = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func moveTo(worldPos):
	if movingQueue.size() > 0:
		movingQueue.append(worldPos)
	else:
		movingQueue.append(worldPos)
		$Tween.interpolate_property(self, "position", null, worldPos, 2,$Tween.TRANS_EXPO,$Tween.EASE_IN_OUT)
		$Tween.start()
		moving = true
	pass


func _on_Tween_tween_completed(object, key):
	movingQueue.remove(0)
	if movingQueue.size() > 0:
		$Tween.interpolate_property(self, "position", null, movingQueue[0], 2,$Tween.TRANS_EXPO,$Tween.EASE_IN_OUT)
		$Tween.start()
	else:
		moving = false
	pass # Replace with function body.
