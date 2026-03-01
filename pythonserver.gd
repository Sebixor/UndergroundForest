extends Node

const PORT = 5005
var server := TCPServer.new()
var client: StreamPeerTCP = null
var buffer := ""

@onready var character = $"../CharacterBody3D"
@export var enemy_manager: Node

func _ready():
	server.listen(PORT, "127.0.0.1")
	print("Listening on port ", PORT)

func _process(_delta):
	if client == null or client.get_status() != StreamPeerTCP.STATUS_CONNECTED:
		if server.is_connection_available():
			client = server.take_connection()
			print("Python connected")

	if client == null or client.get_status() != StreamPeerTCP.STATUS_CONNECTED:
		return

	var available = client.get_available_bytes()
	if available > 0:
		buffer += client.get_string(available)
		while "\n" in buffer:
			var idx = buffer.find("\n")
			var line = buffer.substr(0, idx).strip_edges()
			buffer = buffer.substr(idx + 1)
			_handle_gesture(line)

func _handle_gesture(gesture: String):
	if not is_instance_valid(character):
		return

	match gesture:
		"RUN":
			character.set_running(true)
			character.set_move_input(0, -1)

		"LOOK LEFT":
			character.set_running(false)
			character.set_look_input(-1, 0)

		"LOOK RIGHT":
			character.set_running(false)
			character.set_look_input(1, 0)

		"LOOK UP":
			character.set_running(false)
			character.set_look_input(0, -1)

		"LOOK DOWN":
			character.set_running(false)
			character.set_look_input(0, 1)

		"INTERACT":
			character.set_running(false)
			character.set_move_input(0, 0)
			character.try_interact()

		"HIDE":
			print("HIDE RECEIVED")
			character.set_running(false)
			character.set_move_input(0, 0)
			if is_instance_valid(enemy_manager):
				enemy_manager.on_hide_gesture()
