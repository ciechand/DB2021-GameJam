extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var moving = false
var movingQueue = []
var curBusTile = Vector2(7,3)
var previousVec = Vector2(0,1)
var previousDirection = -1

# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func addMove(worldPos):
	movingQueue.append(worldPos)
	if !moving:
		moveTo()
	pass

func moveTo():
	var angle = Vector2(0,1).angle_to(position-movingQueue[0])
	$Tween.interpolate_property(self, "rotation", null, angle, 0.1,$Tween.TRANS_LINEAR,$Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "position", null, movingQueue[0], 1.5,$Tween.TRANS_EXPO,$Tween.EASE_IN_OUT,0.1)
	$Tween.start()
	moving = true
	previousVec = position-movingQueue[0]
	movingQueue.remove(0)
	pass


func _on_Tween_tween_completed(object, key):
	if key == ":position":
		if animation == "Entrance":
			animation = "Default"
			playing = false
			position -= Vector2(0,4)
		if movingQueue.size() == 0:
			moving = false
		else:
			moveTo()
		curBusTile = get_parent().get_parent().worldToMap(position)
	pass # Replace with function body.


func _on_Bus_animation_finished():
	addMove(position+Vector2(0,-8))
	pass # Replace with function body.
