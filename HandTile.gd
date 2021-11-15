extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tileData = Vector3(0,0,0)
var shown = false
var destroy = false
var mouseOver = false
var handID = 0
onready var Tween = get_node("Tween")

# Called when the node enters the scene tree for the first time.
func _ready():
	region_rect.position.x = tileData[0]*20
	flip_h = false if tileData[1] == 0 else true
	flip_v = false if tileData[2] == 0 else true
	set_process_input(true)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and mouseOver:
			get_node("/root/Map").grabTile(handID)
	pass

func showHand():
	Tween.interpolate_property(self, "scale", Vector2(0.3, 0),Vector2(0.5,0.5), 0.3)
	Tween.interpolate_property(get_parent(), "position", Vector2(113,970), get_parent().position, 0.3)
	Tween.start()
	shown = true
	pass

func hideHand():
	$AnimationPlayer.stop()
	Tween.interpolate_property(self, "scale", Vector2(0.5, 0.5),Vector2(0.3,0), 0.3)
	Tween.interpolate_property(get_parent(), "position", get_parent().position,Vector2(113,970), 0.3)
	Tween.start()
	shown = false
	destroy = true
	pass

func _on_Tween_tween_completed(object, key):
	if destroy:
		get_parent().queue_free()
	else:
		$AnimationPlayer.play()
	pass # Replace with function body.


func _on_Area2D_mouse_entered():
	mouseOver = true
	pass # Replace with function body.


func _on_Area2D_mouse_exited():
	mouseOver = false
	pass # Replace with function body.
