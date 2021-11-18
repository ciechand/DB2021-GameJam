extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tileData = Vector3(0,0,0)
var shown = false
var destroy = false
var mouseOver = false
var handID = 0
var add = false
var rng = RandomNumberGenerator.new()
onready var Tween = get_node("Tween")

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	region_rect.position.x = tileData[0]*20
	flip_h = false if tileData[1] == 0 else true
	flip_v = false if tileData[2] == 0 else true
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and mouseOver:
			get_node("/root/Map").grabTile(handID)
	pass

func showHand():
	if !add:
		Tween.interpolate_property(self, "scale", Vector2(0.3, 0),Vector2(0.5,0.5), 0.3)
		Tween.interpolate_property(get_parent(), "position", Vector2(113,970), get_parent().position, 0.3)
		Tween.start()
		shown = true
	pass

func hideHand():
	if !add:
		$AnimationPlayer.stop()
		Tween.interpolate_property(self, "scale", Vector2(0.5, 0.5),Vector2(0.3,0), 0.3)
		Tween.interpolate_property(get_parent(), "position", get_parent().position,Vector2(113,970), 0.3)
		Tween.start()
		shown = false
		destroy = true
	pass

func spawn(data,id):
	tileData = data
	handID = id
	set_process_input(false)
	$AnimationPlayer.stop()
	get_parent().position = Vector2(100,-80)+Vector2((rng.randi()%120)-60,0)
	Tween.interpolate_property(get_parent(), "position", get_parent().position,Vector2(100,970), 1.2,$Tween.TRANS_QUAD,$Tween.EASE_IN)
	Tween.start()
	destroy = true
	add = true
	pass

func _on_Speaker_finished():
	get_parent().queue_free()
	pass

func _on_Tween_tween_completed(object, key):
	if add and destroy:
		$Speaker.play()
		add = false
	elif destroy:
		get_parent().queue_free()
	else:
		set_process_input(true)
		$AnimationPlayer.play()
	pass # Replace with function body.


func _on_Area2D_mouse_entered():
	mouseOver = true
	pass # Replace with function body.


func _on_Area2D_mouse_exited():
	mouseOver = false
	pass # Replace with function body.
