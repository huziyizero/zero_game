
extends Node2D

var eye_index = 1001
var eye_index_range = [1001, 1017]

var helm_index = 2000
var helm_index_range = [2000, 2038]

var helm2_index = 2983
var helm2_index_range = [2983, 2999]

var weapon_index = 1000
var weapon_index_range = [1000, 1033]

var blood_head_index = 1
var blood_head_range = [1, 4]

var blood_body_index = 1
var blood_body_range = [1, 4]

var skin_index = 3001
var skin_rang = [3001, 3038]

var spine_front = null
var spine_back = null
var spine_side = null
func _ready():
	spine_front = get_node("spine_front")
	spine_back = get_node("spine_back")
	spine_side = get_node("spine_side")
	# 眼睛
	set_attachment_all("hero-eye", "hero-front-eye-1006") #1001 - 1017
	# 头盔
	set_attachment_all("hero-helm", "helm/hero-front-helm-2000") #2000-2038 2983-2999
	# 嘴
	set_attachment_all("hero-mouth", "hero-front-mouth-2001") #2001 - 2017
	# 武器
	set_attachment_all("hero-weapon", "weapon/hero-front-weapon-0") # 0 1000-1033
	# 头上的血
	set_attachment_all("fx_blood_head", "blood/fx-blood-head-side-2") # 1 - 4
	# 身上的血
	set_attachment_all("fx_blood_body", "blood/fx-blood-body-side-2") # 1 - 4
	# 衣服
	set_skin_all("3001")

func set_attachment_all(bone, name):
	spine_front.set_attachment(bone, name)
	spine_side.set_attachment(bone, name)
	spine_back.set_attachment(bone, name)

# 设置眼睛
func set_eye_all(index):
	spine_front.set_attachment("hero-eye", "hero-front-eye-%d"%[index])
	spine_side.set_attachment("hero-eye", "hero-side-eye-%d"%[index])

# 设置头盔
func set_helm_all(index):
	spine_front.set_attachment("hero-helm", "helm/hero-front-helm-%d" %[index])
	spine_side.set_attachment("hero-helm", "helm/hero-side-helm-%d" %[index])
	spine_back.set_attachment("hero-helm", "helm/hero-back-helm-%d" %[index])

# 设置装备
func set_skin_all(skin):
	spine_front.set_skin(skin)
	spine_side.set_skin(skin)
	spine_back.set_skin(skin)

# 设置武器
func set_weapon_all(index):
	spine_front.set_attachment("hero-weapon", "weapon/hero-front-weapon-%d" %[index])
	spine_side.set_attachment("hero-weapon", "weapon/hero-side-weapon-%d" %[index])
	spine_back.set_attachment("hero-weapon", "weapon/hero-back-weapon-%d" %[index])

#========================
# 按钮事件
#========================

func _on_eye_pressed():
	eye_index += 1
	if eye_index > eye_index_range[1]:
		eye_index = eye_index_range[0]
	set_eye_all(eye_index)


func _on_helm_pressed():
	helm_index += 1
	if helm_index > helm_index_range[1]:
		helm_index = helm_index_range[0]
	set_helm_all(helm_index)

func _on_helm2_pressed():
	helm2_index += 1
	if helm2_index > helm2_index_range[1]:
		helm2_index = helm2_index_range[0]
	set_helm_all(helm2_index)


func _on_weapon_pressed():
	weapon_index += 1
	if weapon_index > weapon_index_range[1]:
		weapon_index = weapon_index_range[0]
	set_weapon_all(weapon_index)

func _on_blood_head_pressed():
	blood_head_index += 1
	if blood_head_index > blood_head_range[1]:
		blood_head_index = blood_head_range[0]
	set_attachment_all("fx_blood_head", "blood/fx-blood-head-side-%d" %[blood_head_index])

func _on_blood_body_pressed():
	blood_body_index += 1
	if blood_body_index > blood_body_range[1]:
		blood_body_index = blood_body_range[0]
	set_attachment_all("fx_blood_body", "blood/fx-blood-body-side-%d" %[blood_body_index])

func _on_skin_pressed():
	skin_index += 1
	if skin_index > skin_rang[1]:
		skin_index = skin_rang[0]

	set_skin_all(str(skin_index))
