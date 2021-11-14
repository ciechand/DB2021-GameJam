extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var directions = {
	"South":0,
	"SouthWest":1,
	"NorthWest":2,
	"North":3,
	"NorthEast":4,
	"SouthEast":5
};

var Tiles = {
	"Desert":[Vector3(1,0,0)],
	"Water":[Vector3(2,0,0),Vector3(2,0,1),Vector3(2,1,0),Vector3(2,1,1)],
	"Cactus":[Vector3(3,0,0),Vector3(3,1,0)],
	"Road-0-1":[Vector3(6,0,0)],
	"Road-0-2":[Vector3(5,0,0)],
	"Road-0-3":[Vector3(4,0,0)],
	"Road-0-4":[Vector3(5,1,0)],
	"Road-0-5":[Vector3(6,1,0)],
	"Road-1-3":[Vector3(5,0,1)],
	"Road-1-4":[Vector3(7,0,1)],
	"Road-1-5":[Vector3(8,0,0)],
	"Road-2-3":[Vector3(6,0,1)],
	"Road-2-4":[Vector3(8,0,1)],
	"Road-2-5":[Vector3(7,0,0)],
	"Road-3-4":[Vector3(6,1,1)],
	"Road-3-5":[Vector3(5,1,1)],
	"River-0-1":[Vector3(11,0,0)],
	"River-0-2":[Vector3(10,0,0)],
	"River-0-3":[Vector3(9,0,0)],
	"River-0-4":[Vector3(10,1,0)],
	"River-0-5":[Vector3(11,1,0)],
	"River-1-3":[Vector3(10,0,1)],
	"River-1-4":[Vector3(10,0,1)],
	"River-1-5":[Vector3(13,0,0)],
	"River-2-3":[Vector3(11,0,1)],
	"River-2-4":[Vector3(10,0,1)],
	"River-2-5":[Vector3(13,0,0)],
	"River-3-4":[Vector3(11,1,1)],
	"River-3-5":[Vector3(10,1,1)]
};

var rng = RandomNumberGenerator.new()

var handTile = preload("res://HandTileTemplate.tscn")
var hand = [2]
var handShowing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	print("Starting generation");
	for x in range(-1,15):
		for y in range(ceil(x/2)-x,ceil(x/2)-x+8):
			var randomTile = Tiles[Tiles.keys()[rng.randi()%Tiles.size()]]
			var randomRotation = rng.randi()%randomTile.size() if randomTile.size()>1 else 0
			randomTile = randomTile[randomRotation]
			$HexMapNode/HexMap.set_cell(x,y,randomTile[0],randomTile[1],randomTile[2])
			#print("%d, %d - %d" % [x,y,randomTile[0]])

	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var Map = get_node("HexMapNode")
	if Input.is_action_pressed("ui_up"):
		Map.position += Vector2(0,5)
	if Input.is_action_pressed("ui_down"):
		Map.position -= Vector2(0,5)
	if Input.is_action_pressed("ui_left"):
		Map.position += Vector2(5,0)
	if Input.is_action_pressed("ui_right"):
		Map.position -= Vector2(5,0)
	pass

func _on_TextureRect_pressed():
	if handShowing:
		for i in $Hand.get_children():
			i.get_node("HandTile").hideHand()
		handShowing = !handShowing
	else:
		for i in hand.size():
			var tempHandTile = handTile.instance()
			tempHandTile.position = Vector2(500.0+(i*20*8),500.0)
			tempHandTile.get_node("HandTile").tileNum = hand[i]
			$Hand.add_child(tempHandTile, true)
			tempHandTile.get_node("HandTile").showHand()
		handShowing = !handShowing
	pass # Replace with function body.

