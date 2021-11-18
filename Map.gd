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

var roads = [4,5,6,7,8,15,17]
var rivers = [9,10,11,12,13,16,18]

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
	"Road-0-2-4":[Vector3(17,0,0)],
	"Road-1-3-5":[Vector3(17,0,1)],
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
	"River-0-2-4":[Vector3(18,0,0)],
	"River-1-3-5":[Vector3(18,0,1)],

};

var IODir = {
	Vector3(2,0,0):[0,1,2,3,4,5],
	Vector3(2,0,1):[0,1,2,3,4,5],
	Vector3(2,1,0):[0,1,2,3,4,5],
	Vector3(2,1,1):[0,1,2,3,4,5],
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
	Vector3(17,0,0):[0,2,4],
	Vector3(17,0,1):[1,3,5],
	Vector3(18,0,0):[0,2,4],
	Vector3(18,0,1):[1,3,5],
};

var rng = RandomNumberGenerator.new()

var placing = false
var handTile = preload("res://HandTileTemplate.tscn")
var boat = preload("res://Boat.tscn")
var cactus = preload("res://Cactus.tscn")
var stopSign = preload("res://stopSign.tscn")
var message = preload("res://Message.tscn")
var issue = ""
var hand = [Vector3(4,0,0),Vector3(4,0,0),Vector3(4,0,0),Vector3(4,0,0),]
var handStaging = []
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
	addRandToHand(20)

	#ghosttile invisibility set
	$HexMapNode/GhostTile.visible = false
	$Camera/HandButton.grab_focus()
	#Preparing the bus
	var busStart = mapToWorld(Vector2(7,3),true)
	$HexMapNode/Bus.position = busStart+Vector2(0,-14)
	$HexMapNode/Bus.play()
	pass


func printMessage(messageText=issue,messagetype=0):
	var newMessage = message.instance()
	newMessage.position = get_viewport().size*Vector2(0.5,0.5)
	newMessage.get_node("Panel/Text").text = messageText
	$Camera.add_child(newMessage, true)
	if messagetype == 0:
		newMessage.get_node("Panel").set("custom_styles/panel", load("res://ErrorMessage.tres"))
	elif messagetype ==1:
		newMessage.get_node("Panel").set("custom_styles/panel", load("res://InfoMessage.tres"))
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and holding and $Camera/Hand/Display.get_children().size() == 0:
			var placed = placeTile(curTile,worldToMap(mousePos))
			if !placed:
				$HexMapNode/GhostTile.modulate = Color(1.0,0.4,0.4)
				printMessage()
			elif event.button_index == BUTTON_LEFT and !event.pressed and holding and $Camera/Hand/Display.get_children().size() == 0:
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
			printMessage("LOREM IPSUM!")

	pass

func _on_Timer_timeout():
	if handStaging.size() > 0:
		var tempTile = handTile.instance()
		$Camera/Hand.add_child(tempTile, true)
		tempTile.get_node("HandTile").spawn(handStaging[0][0], handStaging[0][1])
		hand.append(handStaging[0][0])
		handStaging.remove(0)
	pass

func addRandToHand(count=1):
	for i in count:
		var randomTile = Tiles[Tiles.keys()[rng.randi()%Tiles.size()]]
		var randomRotation = rng.randi()%randomTile.size() if randomTile.size()>1 else 0
		var handCount = hand.count(randomTile[randomRotation])
		while handCount > 2: 
			randomTile = Tiles[Tiles.keys()[rng.randi()%Tiles.size()]]
			randomRotation = rng.randi()%randomTile.size() if randomTile.size()>1 else 0
			handCount = hand.count(randomTile[randomRotation])
		handStaging.append([randomTile[randomRotation],i])



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
		for i in $Camera/Hand/Display.get_children():
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
			$Camera/Hand/Display.add_child(tempHandTile, true)
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
				if IODir[adjTiles[t]].has((t+3)%6) and adjTiles[t][0] != 2:
					inputs.append(t)
	if exit:
		issue = "Can only add tile to a space next to the current Map."
		return false
	if hand[handID][0] != 2:
		if IODir.has(hand[handID]):
			var curTileIO = IODir[hand[handID]]
			for i in inputs:
				if !curTileIO.has(i):
					issue = "Output of existing tile Does not align with an input of held tile."
					return false
			for c in curTileIO:
				var adjTile = int(adjTiles[c][0])
				var handTile = int(hand[handID][0])
				if  inputs.has(c):
					if roads.has(handTile) and (roads.has(adjTile) or adjTile == 14): 
						pass
					elif rivers.has(handTile) and (rivers.has(adjTile) or adjTile == 2):
						pass
					else:
						issue = "Roads cannot connect to Rivers and Visa-Versa."
						return false
				else:
					if (rivers.has(handTile) and adjTile == 2):
						pass
					elif adjTile != -1:
						issue = "Output from held tile cannot align with side without input."
						return false
		elif inputs.size() > 0:
			if hand[handID][0] != 2:
				issue = "Held Tile does not have a path, it cannot accept Outputs fom existing tiles."
				return false
			elif hand[handID][0] == 2:
				for t in adjTiles:
					if roads.has(t[0]) or t[0] == 14:
						issue = "This Bus is not designed for water travel."
						return false
			

	if $HexMapNode/HexMap.get_cellv(mapPos) == -1:

		$HexMapNode/HexMap.set_cellv(mapPos,hand[handID][0],hand[handID][1],hand[handID][2])

		#Move the Bus
		navigateRoad($HexMapNode/Bus, mapPos)
		
		var id = int(hand[handID][0])
		var additive = 0
		if roads.has(id):
			additive += 2
		elif rivers.has(id):
			additive += 1
		elif id == 1:
			additive += 2
		elif id == 3:
			additive += 5
		elif id == 2:
			additive += 5
			var boatInstance = boat.instance()
			$HexMapNode.add_child(boatInstance,true)
			boatInstance.position = mapToWorld(mapPos,true)+Vector2(rng.randi()%80,rng.randi()%80)-Vector2(40,40)-Vector2(0,1000)
			boatInstance.addMove(boatInstance.position+Vector2(0,1000))
			boatInstance.curTile = mapPos
			navigateRiver(boatInstance)
			printMessage("Happy Sailing!",1)
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
	if !([1,2,3,4]+rivers).has(tileID):
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
				printMessage("Dance Party!",1)
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
						printMessage("Dance Party!",1)
	elif tileID == 2:
		for t in surroundingTiles:
			if !rivers.has(int(t[0])) and t[0] != 2:
				return 0
		add += 20
	elif rivers.has(tileID):
		for t1 in surroundingTiles.size():
			if surroundingTiles[t1][0] == 2:
				var dir = evenDirections[t1] if int(checkTile.x)%2 == 0 else oddDirections[t1]
				var adjTiles = queryAdjTiles(checkTile+dir)
				for t2 in adjTiles:
					if !rivers.has(int(t2[0])) and t2[0] != 2:
						return 0
				add += 15
	elif tileID == 4:
		var upTile = surroundingTiles[3]
		var downTile = surroundingTiles[0]
		if upTile[0] == 4 and downTile[0] == 4:
			var signInstance = stopSign.instance()
			$HexMapNode.add_child(signInstance,true)
			signInstance.position = mapToWorld(checkTile,true)+Vector2(30,0)-Vector2(0,1000)
			signInstance.addMove(signInstance.position+Vector2(0,1000))	
			printMessage("No one to pick up! As usual.",1)
			add += 10
			pass
		elif upTile[0] == 4:
			var dir = evenDirections[3] if int(checkTile.x)%2 == 0 else oddDirections[3]
			var upupTile = queryTile(checkTile+dir,3)
			if upupTile[0] == 4:
				var signInstance = stopSign.instance()
				$HexMapNode.add_child(signInstance,true)
				signInstance.position = mapToWorld(checkTile+dir,true)+Vector2(30,0)-Vector2(0,1000)
				signInstance.addMove(signInstance.position+Vector2(0,1000))	
				printMessage("No one to pick up! As usual.",1)
				add += 10
				pass
		elif downTile[0] ==4:
			var dir = evenDirections[0] if int(checkTile.x)%2 == 0 else oddDirections[0]
			var downdownTile = queryTile(checkTile+dir,0)
			if downdownTile[0] == 4:
				var signInstance = stopSign.instance()
				$HexMapNode.add_child(signInstance,true)
				signInstance.position = mapToWorld(checkTile+dir,true)+Vector2(30,0)-Vector2(0,1000)
				signInstance.addMove(signInstance.position+Vector2(0,1000))	
				printMessage("No one to pick up! As usual.",1)
				add += 10
				pass
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

func navigateRoad(obj,placedTile):
	var path = []
	var count = 0
	var curTilePos = obj.curTile
	var IO = IODir[queryTile(curTilePos)].duplicate()
	while true:
		if count >= 1000:
			for i in 100:
				printMessage("GAME OVER")
				$Camera/ExitButton.visible = true
				$Camera/ExitButton.disabled = false
			return	
		var outputs = []
		var validOutputs = [] 
		for o in IO:
			var dir = evenDirections[o] if int(curTilePos.x)%2 == 0 else oddDirections[o]
			if curTilePos+dir == placedTile and count == 0:
				outputs = [o]
				break
			if queryTile(curTilePos, o)[0] != -1 and (o != obj.previousDirection and queryTile(curTilePos, o)[0] != 14):
				if !path.has([curTilePos,o]):
					outputs.append(o)
			elif queryTile(curTilePos,o)[0] == -1 and count != 0:
				if path.has([curTilePos,o]):
					validOutputs.append(o)
		if outputs.size() == 0:
			if validOutputs.size() !=0:
				outputs = validOutputs
			else:
				#print("EMPTY PATH")
				return
		var finalOutput = outputs[rng.randi()%outputs.size()]
		var dir = evenDirections[finalOutput] if int(curTilePos.x)%2 == 0 else oddDirections[finalOutput]
		obj.previousDirection = (finalOutput+3)%6
		path.append([curTilePos,finalOutput])
		curTilePos = curTilePos+dir
		obj.addMove(mapToWorld(curTilePos,true))
		if queryTile(curTilePos)[0] == -1:
			return
		IO = IODir[queryTile(curTilePos)].duplicate()
		count += 1
	pass

func navigateRiver(obj):
	var curTilePos = obj.curTile
	var IO = IODir[queryTile(curTilePos)].duplicate()
	var outputs = []
	for o in IO:
		var tile = int(queryTile(curTilePos, o)[0])
		if tile != -1 and o != obj.previousDirection and (rivers.has(tile) or tile == 2) and IODir[queryTile(curTilePos,o)].has((o+3)%6):
			outputs.append(o)
	if outputs.size() == 0:
		#print("EMPTY PATH")
		return
	var finalOutput = outputs[rng.randi()%outputs.size()]
	var dir = evenDirections[finalOutput] if int(curTilePos.x)%2 == 0 else oddDirections[finalOutput]
	obj.previousDirection = (finalOutput+3)%6
	obj.addMove(mapToWorld(curTilePos+dir,true))
	pass
func _on_Exit_button_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
	pass
