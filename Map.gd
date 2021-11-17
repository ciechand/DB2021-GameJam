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

var placing = false
var handTile = preload("res://HandTileTemplate.tscn")
var boat = preload("res://Boat.tscn")
var cactus = preload("res://Cactus.tscn")
var message = preload("res://Message.tscn")
var issue = ""
var hand = [Vector3(1,0,0),Vector3(1,0,0),Vector3(1,0,0),Vector3(1,0,0),Vector3(1,0,0),Vector3(1,0,0),Vector3(1,0,0),Vector3(1,0,0),Vector3(3,0,0)]
var handShowing = false
var curTile = -1
var holding = false
var tileUntilMove = 3
var tilePoints = 0
var points = 0
var mousePos = Vector2(0,0)


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

	#Setting up a starting Hand
	addRandToHand(10)

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
			var placed = placeTile(curTile,worldToMap(mousePos))
			if !placed:
				$HexMapNode/GhostTile.modulate = Color(1.0,0.4,0.4)
				var newMessage = message.instance()
				newMessage.position = get_viewport().size*Vector2(0.5,0.5)
				newMessage.get_node("Panel/Text").text = issue
				$Camera.add_child(newMessage, true)
			elif event.button_index == BUTTON_LEFT and !event.pressed and holding and $Camera/Hand.get_children().size() == 0:
				$HexMapNode/GhostTile.modulate = Color(1.0,1.0,1.0)

	if event is InputEventMouseMotion:
		mousePos = get_global_mouse_position()
		if $HexMapNode/GhostTile.visible == true:
			$HexMapNode/GhostTile.position = mapToWorld(worldToMap(mousePos))
			if $HexMapNode/HexMap.get_cellv(worldToMap(mousePos)) != -1:
				$HexMapNode/GhostTile.modulate = Color(1.0,0.4,0.4)
			else:
				$HexMapNode/GhostTile.modulate = Color(1.0,1.0,1.0)

	if event is InputEventKey:
		if event.scancode == KEY_L:
			var newMessage = message.instance()
			newMessage.position = get_viewport().size*Vector2(0.5,0.5)
			$Camera.add_child(newMessage, true)

	pass

func addRandToHand(count=1):
	for i in count:
		var randomTile = Tiles[Tiles.keys()[rng.randi()%Tiles.size()]]
		var randomRotation = rng.randi()%randomTile.size() if randomTile.size()>1 else 0
		hand.append(randomTile[randomRotation])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Camera/Points.text = "Points: "+String(points)

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

func placeTile(handID, mapPos)->bool:
	if $HexMapNode/Bus.moving:
		issue = "Cannot place Road while Car is Moving."
		return false
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
		issue = "Can only add tile to a space next to the current Map."
		return false

	if IODir.has(hand[handID]):
		var curTileIO = IODir[hand[handID]]
		for i in inputs:
			if !curTileIO.has(i):
				issue = "Output of existing tile Does not align with an input of held tile."
				return false
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
			issue = "Input/Output of held tile is not aligned with a valid Input/Output."
			return false
	elif inputs.size() > 0 and hand[handID][0] != 2:
		issue = "Held Tile does not have a path, it cannot accept Outputs fom existing tiles."
		return false

	if $HexMapNode/HexMap.get_cellv(mapPos) == -1:

		$HexMapNode/HexMap.set_cellv(mapPos,hand[handID][0],hand[handID][1],hand[handID][2])

		#Move the Bus
		navigatePath($HexMapNode/Bus)
		
		var id = int(hand[handID][0])
		var additive = 0
		if roads.has(id):
			additive += 2
		elif rivers.has(id):
			additive += 2
		elif id == 1:
			additive += 1
		elif id == 3:
			additive += 3
		elif id == 2:
			additive += 3
			var boatInstance = boat.instance()
			$HexMapNode.add_child(boatInstance,true)
			boatInstance.position = mapToWorld(mapPos,true)+Vector2(rng.randi()%80,rng.randi()%80)-Vector2(40,40)-Vector2(0,1000)
			boatInstance.addMove(boatInstance.position+Vector2(0,1000))
			#boatInstance.curTile = Vector2(mapPos)
		else:
			pass
		additive += checkPatterns(mapPos)
		tilePoints += additive
		points += additive

		if tilePoints >= 5:
			var deduction = floor(tilePoints/5)
			addRandToHand(deduction)
			tilePoints -= deduction*5

		#Clear the hand
		hand.remove(handID)
		curTile = -1
		holding = false
		$HexMapNode/GhostTile.visible = false
	return true

func checkPatterns(checkTile)->int:
	var tileID = $HexMapNode/HexMap.get_cellv(checkTile)
	if !([1,2,3]+rivers).has(tileID):
		return 0
	var surroundingTiles = queryAdjTiles(checkTile)
	var add = 0
	if tileID == 3:
		for t in surroundingTiles:
			if t[0] != 1:
				return 0
		add += 15
		for d in 6:
			var dir = evenDirections[d] if int(checkTile.x)%2 == 0 else oddDirections[d]
			for i in 2:
				var cactusInstance = cactus.instance()
				$HexMapNode.add_child(cactusInstance,true)
				cactusInstance.position = mapToWorld(checkTile+dir,true)+Vector2(rng.randi()%80,rng.randi()%80)-Vector2(40,40)-Vector2(0,1000)
				cactusInstance.addMove(cactusInstance.position+Vector2(0,1000))	
	elif tileID == 1:
		for t1 in surroundingTiles.size():
			if surroundingTiles[t1][0] == 3:
				var dir = evenDirections[t1] if int(checkTile.x)%2 == 0 else oddDirections[t1]
				var adjTiles = queryAdjTiles(checkTile+dir)
				for t2 in adjTiles:
					if t2[0] != 1:
						return 0
				add += 15
				for d in 6:
					var dir2 = evenDirections[d] if int((checkTile+dir).x)%2 == 0 else oddDirections[d]
					for i in 2:
						var cactusInstance = cactus.instance()
						$HexMapNode.add_child(cactusInstance,true)
						cactusInstance.position = mapToWorld(checkTile+dir+dir2,true)+Vector2(rng.randi()%80,rng.randi()%80)-Vector2(40,40)-Vector2(0,1000)
						cactusInstance.addMove(cactusInstance.position+Vector2(0,1000))	
	elif tileID == 2:
		for t in surroundingTiles:
			if !rivers.has(int(t[0])):
				return 0
		add += 20
	elif rivers.has(tileID):
		for t1 in surroundingTiles.size():
			if surroundingTiles[t1][0] == 2:
				var dir = evenDirections[t1] if int(checkTile.x)%2 == 0 else oddDirections[t1]
				var adjTiles = queryAdjTiles(checkTile+dir)
				for t2 in adjTiles:
					if !rivers.has(int(t2[0])):
						return 0
				add += 15
	return add


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
	var path = []
	var ct = 0
	var curTilePos = obj.curTile
	var dirNum = IODir[queryTile(curTilePos)].duplicate()
	dirNum.erase(obj.previousDirection)
	var dir = evenDirections[dirNum[0]] if int(curTilePos.x)%2 == 0 else oddDirections[dirNum[0]]
	var nextTilePos = curTilePos+dir
	while queryTile(curTilePos,dirNum[0])[0] != -1:
		if path.has(curTilePos):
			tilePoints += path.size()
			return
		path.append(curTilePos)
		obj.previousDirection = (dirNum[0]+3)%6
		obj.addMove(mapToWorld(nextTilePos,true))
		curTilePos = nextTilePos
		dirNum = IODir[queryTile(nextTilePos)].duplicate()
		dirNum.erase(obj.previousDirection)
		dir = evenDirections[dirNum[0]] if int(curTilePos.x)%2 == 0 else oddDirections[dirNum[0]]
		nextTilePos = curTilePos+dir
		ct += 1
		if interations != -1 and ct >= interations:
			break
	pass
