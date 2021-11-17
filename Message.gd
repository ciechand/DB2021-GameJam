extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Panel.rect_position = -($Panel.rect_size/2)
	$Collision.shape.radius = $Panel.rect_size.y/2
	$Collision.shape.height = $Panel.rect_size.x/2
	#$Collision.position = $Panel.rect_size/2
	pass

func _on_Timer_timeout():
	self.queue_free()
	pass
