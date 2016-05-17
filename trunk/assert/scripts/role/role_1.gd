
extends RigidBody2D

var anim = null
var is_up = false
var is_left = false
var is_right = false
var is_down = false

var MOVE_SPEED = 2000
var MAX_MOVE_SPEED = 500
var MAX_JUMP_VEC = 200

var cur_anim_name = ""

var jumping = false
var found_floor = false

func _ready():
	anim = get_node("anim")


func _integrate_forces(s):
	var lv = s.get_linear_velocity()
	var step = s.get_step()
	
	var new_anim = ""
	
	is_up = Input.is_action_pressed("up")
	is_down = Input.is_action_pressed("down")
	is_left = Input.is_action_pressed("left")
	is_right = Input.is_action_pressed("right")
	
	if is_right:
		new_anim = "right"
		if abs(lv.x) < MAX_MOVE_SPEED:
			lv.x += MOVE_SPEED*step

	if is_left:
		new_anim = "left"
		if abs(lv.x) < MAX_MOVE_SPEED:
			lv.x -= MOVE_SPEED*step
	
	if not is_right and not is_left:
		new_anim = "stand"
		
	if is_up and not jumping:
			lv.y -= 400
			jumping = true
			
	if jumping:
		lv.y += 30
			
	for x in range(s.get_contact_count()):
		var ci = s.get_contact_local_normal(x)
		if (ci.dot(Vector2(0, -1)) > 0.6):
			found_floor = true
			jumping = false
	
	lv += s.get_total_gravity()*step
	s.set_linear_velocity(lv)
	
	if new_anim != cur_anim_name:
		cur_anim_name = new_anim
		if new_anim == "right":
			set_scale(Vector2(1, 1))
		elif new_anim == "left":
			set_scale(Vector2(-1, 1))
		elif new_anim == "stand":
			anim.stop()
			return
			
		anim.play(new_anim)


