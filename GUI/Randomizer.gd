extends Control
onready var p=get_parent()

func _ready():
	pass

func _randomize():
	_randomizeGUIvalues()
	_randomizeBones()
	_randomizeShapes()
	
func _randomizeGUIvalues():
	randomize()
	for slider in p.slidersArray:
		if slider.get_parent().name=="w_eyeBrowHeight":
			slider.value=rand_range(-4.9,-5.1)
		else:
			slider.value=rand_range(0,slider.max_value)
			
	var count:int=-1
	var random = randi()%p.colorPresetsDict.hairColor.size()
	for h in p.colorPresetsDict.hairColor:
		count+=1
		if count==random:
			p.colorPresetsDict.hairColor[h].emit_signal("pressed")
			p.colorPresetsDict.beardColor[h].emit_signal("pressed")

			
	count=-1
	random = randi()%p.colorPresetsDict.eyesColor.size()
	for h in p.colorPresetsDict.eyesColor:
		count+=1
		if count==random:
			p.colorPresetsDict.eyesColor[h].emit_signal("pressed")
#			p.colorPresetSelected.eyeColorPresets=h
	count=-1
	random = randi()%p.colorPresetsDict.skinTone.size()
	for h in p.colorPresetsDict.skinTone:
		count+=1
		if count==random:
			p.colorPresetsDict.skinTone[h].emit_signal("pressed")
#			p.colorPresetSelected.skinTonePresets=h
	var randPaintColor:Color = Color(rand_range(0,1),rand_range(0,1),rand_range(0,1))
	p.get_node("Panel/vb/head/vb/facePaintColor_head").color=randPaintColor
	p.get_node("Panel/vb/head/vb/facePaintColor_head")._on_colorPicker_color_changed(randPaintColor)
	
func _randomizeBones():
	var sk = p.character.get_node("MainRig")
	randomize()
	#-------3 STEPS FOR READABILITY
	for i in 3:
		if i==0:
			var scaleLimit:float=0.03
			var t:Transform
			var headScale=rand_range(0.9,1.1)
			t=t.scaled(Vector3(1,1,1)*headScale)
			sk.set_bone_custom_pose(sk.find_bone("head"),t)	
				
			var t2:Transform
			t2=t2.translated(Vector3(0,rand_range(-scaleLimit,scaleLimit),0))
			sk.set_bone_custom_pose(sk.find_bone("shoulder_L"),t2)		
			sk.set_bone_custom_pose(sk.find_bone("shoulder_R"),t2)	
			
			var t3:Transform
			t3=t3.translated(Vector3(0,rand_range(-scaleLimit,scaleLimit),0))
			sk.set_bone_custom_pose(sk.find_bone("spine3"),t3)
			
		if i==1:
			var scaleLimit:float=0.02
			var t:Transform			
			t=t.translated(Vector3(0,rand_range(-scaleLimit,scaleLimit),0))
			sk.set_bone_custom_pose(sk.find_bone("spine1"),t)
			
			var t2:Transform
			t2=t2.translated(Vector3(0,rand_range(-scaleLimit,scaleLimit),0))
			sk.set_bone_custom_pose(sk.find_bone("spine2"),t2)
			
			var t3:Transform
			t3=t3.translated(Vector3(0,rand_range(-scaleLimit,scaleLimit),0))
			sk.set_bone_custom_pose(sk.find_bone("forearm_R"),t3)			
			sk.set_bone_custom_pose(sk.find_bone("forearm_L"),t3)	
			
			var t4:Transform
			scaleLimit=0.005
			t4=t4.translated(Vector3(0,rand_range(-scaleLimit,scaleLimit),0))
			sk.set_bone_custom_pose(sk.find_bone("upper_arm_R"),t4)	
			sk.set_bone_custom_pose(sk.find_bone("upper_arm_L"),t4)		

		if i==2:
			var scaleLimit:float=0.04
			var t:Transform				
			t=t.translated(Vector3(0,rand_range(-scaleLimit,scaleLimit),0))
			sk.set_bone_custom_pose(sk.find_bone("thigh_R"),t)			
			sk.set_bone_custom_pose(sk.find_bone("thigh_L"),t)			
			sk.set_bone_custom_pose(sk.find_bone("spine"),t*sk.get_bone_custom_pose(sk.find_bone("shin_R")))		
			
			var t2:Transform
			t2=t2.translated(Vector3(0,rand_range(-scaleLimit,scaleLimit),0))
			sk.set_bone_custom_pose(sk.find_bone("shin_R"),t2)			
			sk.set_bone_custom_pose(sk.find_bone("shin_L"),t2)			
			sk.set_bone_custom_pose(sk.find_bone("spine"),t2*sk.get_bone_custom_pose(sk.find_bone("thigh_R")))		
			
			var t3:Transform
			t3=t3.translated(Vector3(0,rand_range(-scaleLimit,scaleLimit),0))
			sk.set_bone_custom_pose(sk.find_bone("toe_R"),t3)			
			sk.set_bone_custom_pose(sk.find_bone("toe_L"),t3)	
	p.get_node("EditBehaviour")._adjustFaceCamHeight()

func _randomizeShapes():
	var head = p.character.get_node("MainRig/head")
	var currentBeard:MeshInstance = p.character.get_node("MainRig").find_node("beard?",true,false)
	var currentHair:MeshInstance = p.character.get_node("MainRig").find_node("hair?",true,false)
	randomize()

	for b in head.mesh.get_blend_shape_count():
		var bs:String = head.mesh.get_blend_shape_name(b)
		
		if bs!="chubby" and bs!="blink": 				#We don't want to tweak this values
			var bsNext:String
			if b<head.mesh.get_blend_shape_count()-1:
				bsNext= head.mesh.get_blend_shape_name(b+1)
			var x = bs.substr(0,bs.length()-1) 			#name (without + -) of this shape
			var y = bsNext.substr(0,bsNext.length()-1)  #name (without + -) of the next shape
			if x==y:									#if it's the same name
				var randValue = randi()%2				#choose one
				var randShapeValue=rand_range(0,1)
				if randValue==0:						#apply blend shape to this value or the next
					head.set("blend_shapes/"+bs,randShapeValue)
					head.set("blend_shapes/"+bsNext,0) #Clear the value in case of multiple randomization
					currentBeard.set("blend_shapes/"+bs,randShapeValue)
					currentHair.set("blend_shapes/"+bs,randShapeValue)
				elif randValue==1:
					head.set("blend_shapes/"+bsNext,randShapeValue)
					head.set("blend_shapes/"+bs,0) #Clear the value in case of multiple randomization
					currentBeard.set("blend_shapes/"+bs,randShapeValue)
					currentHair.set("blend_shapes/"+bs,randShapeValue)		
			
