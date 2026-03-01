extends Node3D
var area: Area3D
var is_held: bool = false
var is_deposited: bool = false

func _ready():
	add_to_group("interactable")
	area = find_child("Area3D")

func pick_up(hand_marker: Node3D):
	is_held = true
	get_parent().remove_child(self)
	hand_marker.add_child(self)
	call_deferred("_snap_to_hand")
	if area != null:
		area.monitoring = false
		area.monitorable = false
	var collision = find_child("CollisionShape3D")
	if collision:
		collision.disabled = true
	var static_body = find_child("StaticBody3D")
	if static_body:
		static_body.collision_layer = 0
		static_body.collision_mask = 0
	var rigid = find_child("RigidBody3D")
	if rigid:
		rigid.freeze = true

func _snap_to_hand():
	transform = Transform3D.IDENTITY
	scale = Vector3(0.01, 0.01, 0.01)
	position = Vector3(-3, -1.5, -3)
	visible = true
	print("SNAP | global pos: ", global_position)
	print("SNAP | parent global pos: ", get_parent().global_position)

func deposit():
	is_held = false
	is_deposited = true
	queue_free()
