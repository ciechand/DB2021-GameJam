extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var evenDirections = {
	-1:Vector2(0,0),
	0:Vector2(0,1),
	1:Vector2(-1,0),
	2:Vector2(-1,-1),
	3:Vector2(0,-1),
	4:Vector2(1,-1),
	5:Vector2(1,0),
};

var oddDirections = {
	-1:Vector2(0,0),
	0:Vector2(0,1),
	1:Vector2(-1,1),
	2:Vector2(-1,0),
	3:Vector2(0,-1),
	4:Vector2(1,0),
	5:Vector2(1,1),
};

var roads = [4,5,6,7,8,15]
var rivers = [9,10,11,12,13,16]

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
	"Road-1-2":[Vector3(15,0,0)],
	"Road-4-5":[Vector3(15,1,0)],
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
	"River-3-5":[Vector3(10,1,1)],
	"River-1-2":[Vector3(16,0,0)],
	"River-4-5":[Vector3(16,1,0)],
};

var IODir = {
	Vector3(4,0,0):[0,3],
	Vector3(5,0,0):[0,2],
	Vector3(5,0,1):[3,1],
	Vector3(5,1,0):[0,4],
	Vector3(5,1,1):[3,5],
	Vector3(6,0,0):[0,1],
	Vector3(6,0,1):[2,3],
	Vector3(6,1,0):[0,5],
	Vector3(6,1,1):[3,4],
	Vector3(7,0,0):[2,5],
	Vector3(7,0,1):[1,4],
	Vector3(8,0,0):[1,5],
	Vector3(8,0,1):[2,4],
	Vector3(9,0,0):[0,3],
	Vector3(10,0,0):[0,2],
	Vector3(10,0,1):[3,1],
	Vector3(10,1,0):[0,4],
	Vector3(10,1,1):[3,5],
	Vector3(11,0,0):[0,1],
	Vector3(11,0,1):[2,3],
	Vector3(11,1,0):[0,5],
	Vector3(11,1,1):[3,4],
	Vector3(12,0,0):[2,5],
	Vector3(12,0,1):[1,4],
	Vector3(13,0,0):[1,5],
	Vector3(13,0,1):[2,4],
	Vector3(14,0,0):[3],
	Vector3(15,0,0):[1,2],
	Vector3(15,1,0):[4,5],
	Vector3(16,0,0):[1,2],
	Vector3(16,1,0):[4,5],
};

var rng = RandomNumberGenerator.new()

var handTile = preload("res://HandTileTemplate.tscn")
var hand = []
var handShowing = false
var curTile = -1
var holding = false
var tileUntilMove = 3
var mousePos = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

	#Setting up a starting Hand
	for i in 50:
		var randomTile = Tiles[Tiles.keys()[rng.randi()%Tiles.size()]]
		var randomRotation = rng.randi()%randomTile.size() if randomTile.size()>1 else 0
		hand.append(randomTile[randomRotation])

	#ghosttile invisibility set
	$HexMapNode/GhostTile.visible = false

	#Preparing the bus
	var busStart = mapToWorld(Vector2(7,3),true)
	$HexMapNode/Bus.position = busStart+Vector2(0,-14)
	$HexMapNode/Bus.play()
	pass


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and holding and $Camera/Hand.get_children().size() == 0:
			placeTile(curTile,worldToMap(mousePos))

	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mousePos = get_global_mouse_position()
	if $HexMapNode/GhostTile.visible == true:
		$HexMapNode/GhostTile.position = mapToWorld(worldToMap(mousePos))
		if $HexMapNode/HexMap.get_cellv(worldToMap(mousePos)) != -1:
			$HexMapNode/GhostTile.modulate = Color(1.0,0.4,0.4)
		else:
			$HexMapNode/GhostTile.modulate = Color(1.0,1.0,1.0)

	var camera = $Camera
	if Input.is_action_pressed("ui_up"):
		camera.position -= Vector2(0,5)
	if Input.is_action_pressed("ui_down"):
		camera.position += Vector2(0,5)
	if Input.is_action_pressed("ui_left"):
		camera.position -= Vector2(5,0)
	if Input.is_action_pressed("ui_right"):
		camera.position += Vector2(5,0)
	pass

func _on_TextureRect_pressed():
	if handShowing:
		for i in $Camera/Hand.get_children():
			i.get_node("HandTile").hideHand()
		handShowing = !handShowing
	else:
		var halfWindowSize = get_viewport().size/2
		rng.randomize()
		for i in hand.size():
			var tempHandTile = handTile.instance()
			var angle = i*2.4+(rng.randf_range(-0.3,0.3)/((i*2.4)+1))
			var dist = 40+(sqrt(i)*60)+((rng.randi()%10)-5)
			tempHandTile.position = Vector2((sin(angle)*dist)+halfWindowSize.x,(cos(angle)*dist)+halfWindowSize.y)
			tempHandTile.get_node("HandTile").tileData = hand[i]
			tempHandTile.get_node("HandTile").handID = i
			$Camera/Hand.add_child(tempHandTile, true)
			tempHandTile.get_node("HandTile").showHand()
		handShowing = !handShowing
		holding = false
		$HexMapNode/GhostTile.visible = false
	pass # Replace with function body.

func getHexID(pos)->Vector3:
	return Vector3($HexMapNode/HexMap.get_cellv(pos),$HexMapNode/HexMap.is_cell_x_flipped(pos.x,pos.y),$HexMapNode/HexMap.is_cell_y_flipped(pos.x,pos.y))

func worldToMap(worldPos)->Vector2:
	return $HexMapNode/HexMap.world_to_map(worldPos/8)

func mapToWorld(mapPos, offset=false)->Vector2:
	var offsetVec = Vector2(4,4)+Vector2(19*4,19*4) if offset else Vector2(0,0)
	return ($HexMapNode/HexMap.map_to_world(mapPos)*8)+offsetVec

func placeTile(handID, mapPos):
	if $HexMapNode/Bus.moving:
		return
	var valid = []
	var inputs = []
	var adjTiles = queryAdjTiles(mapPos)
	var exit = true
	for t in adjTiles.size():
		if adjTiles[t][0] != -1:
			exit = false
			if IODir.has(adjTiles[t]):
				if IODir[adjTiles[t]].has((t+3)%6):
					inputs.append(t)
	if exit:
		return

	if IODir.has(hand[handID]):
		var curTileIO = IODir[hand[handID]]
		for i in inputs:
			if !curTileIO.has(i):
				return
		for c in curTileIO:
			if hand[handID][0] == 2:
				break
			var adjTile = int(adjTiles[c][0])
			var handTile = int(hand[handID][0])
			if  inputs.has(c):
				if roads.has(handTile) and (roads.has(adjTile) or adjTile == 14): 
					valid.append(true)
				elif rivers.has(handTile) and (rivers.has(adjTile) or adjTile == 2):
					valid.append(true)
				else:
					valid.append(false)
			else:
				if (rivers.has(handTile) and adjTile == 2):
					valid.append (true)
				elif adjTile != -1:
					valid.append(false)
		if valid.count(false) > 0:
			return
	elif inputs.size() > 0:
		return

	if $HexMapNode/HexMap.get_cellv(mapPos) == -1:

		$HexMapNode/HexMap.set_cellv(mapPos,hand[handID][0],hand[handID][1],hand[handID][2])

		#Move the Bus
		navigatePath($HexMapNode/Bus)

		#Clear the hand
		hand.remove(handID)
		curTile = -1
		holding = false
		$HexMapNode/GhostTile.visible = false

	pass

func grabTile(tile):
	_on_TextureRect_pressed()
	curTile = tile
	$HexMapNode/GhostTile.visible = true
	$HexMapNode/GhostTile.region_rect.position.x = hand[tile][0]*20
	$HexMapNode/GhostTile.flip_h = hand[tile][1]
	$HexMapNode/GhostTile.flip_v = hand[tile][2]
	holding = true
	pass
	
func queryAdjTiles(tilePos):
	var adjTiles = []
	for i in 6:
		var tempTile = queryTile(tilePos,i)
		adjTiles.append(tempTile)
	return adjTiles

func queryTile(tilePos,dir=-1):
	var tDir = evenDirections[dir] if int(tilePos.x)%2 == 0 else oddDirections[dir]
	var targetTilePos = tilePos+tDir
	var targetTile = $HexMapNode/HexMap.get_cellv(targetTilePos)
	if targetTile == -1:
		return Vector3(-1,0,0)
	else:
		return Vector3(targetTile,$HexMapNode/HexMap.is_cell_x_flipped(targetTilePos.x,targetTilePos.y),$HexMapNode/HexMap.is_cell_y_flipped(targetTilePos.x,targetTilePos.y))

func navigatePath(obj,interations=-1):
	var ct = 0
	var curBusTilePos = obj.curBusTile
	var dirNum = IODir[queryTile(curBusTilePos)].duplicate()
	dirNum.erase(obj.previousDirection)
	var dir = evenDirections[dirNum[0]] if int(curBusTilePos.x)%2 == 0 else oddDirections[dirNum[0]]
	var nextTilePos = curBusTilePos+dir
	while queryTile(curBusTilePos,dirNum[0])[0] != -1:
		obj.previousDirection = (dirNum[0]+3)%6
		obj.addMove(mapToWorld(nextTilePos,true))
		curBusTilePos = nextTilePos
		dirNum = IODir[queryTile(nextTilePos)].duplicate()
		dirNum.erase(obj.previousDirection)
		dir = evenDirections[dirNum[0]] if int(curBusTilePos.x)%2 == 0 else oddDirections[dirNum[0]]
		nextTilePos = curBusTilePos+dir
		ct += 1
		if interations != -1 and ct >= interations:
			break
	pass
