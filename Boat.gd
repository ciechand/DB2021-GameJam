extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var moving = false
var movingQueue = []
var curTile = Vector2(7,3)
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	self.flip_h = true if rng.randi()%2 else false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func addMove(worldPos):
	movingQueue.append(worldPos)
	if !moving:
		moveTo()
	pass

func moveTo():
	$Tween.interpolate_property(self, "position", null, movingQueue[0], 1.5,$Tween.TRANS_EXPO,$Tween.EASE_OUT,0.1)
	$Tween.start()
	moving = true
	movingQueue.remove(0)
	pass


func _on_Tween_tween_completed(object, key):
	if key == ":position":
		if movingQueue.size() == 0:
			moving = false
		else:
			moveTo()
		curTile = get_parent().get_parent().worldToMap(position)
	pass # Replace with function body.
