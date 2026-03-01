extends CharacterBody3D

@export var SPEED: float = 5.0
@export var RUN_MULTIPLIER: float = 2.5

var udp := PacketPeerUDP.new()
var command: String = "IDLE"


func _ready() -> void:
	var err = udp.bind(4242)
	if err != OK:
		print("Failed to bind UDP")
	else:
		print("Listening for Python (UDP)...")


func _physics_process(delta: float) -> void:

	# Receive UDP packets
	while udp.get_available_packet_count() > 0:
		var packet = udp.get_packet()
		command = packet.get_string_from_utf8()
		print("Received:", command)

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction: Vector3 = Vector3.ZERO
	var current_speed: float = 0.0

	if command == "RUN":
		direction = -transform.basis.z
		current_speed = SPEED * RUN_MULTIPLIER

	elif command == "LEFT":
		direction = -transform.basis.x
		current_speed = SPEED

	elif command == "RIGHT":
		direction = transform.basis.x
		current_speed = SPEED

	else:
		current_speed = 0.0

	if direction != Vector3.ZERO:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
