extends Control
var last_position = Vector2()
onready var character = get_parent().get_node("MainCharacter")
var hairName:Array=["Bald","Man Bun","Dad","Gnacker","Tal","Mullet"]
var beardName:Array=["Beardless","Goatie","Amish","Moustache","Cantinflas"]
var subBeard:Array=["Beardless","Hangover","Grut","Bigotelli"]
var facePaintName=["No Face Paint","Shadow","Barb","Glick","Grut","Growl","Snah","Ñecle"]
var eyebrowsName:Array=["None","Snah","Blek","AD"]
var colorPresetsArray:Array=[]
var slidersArray:Array=[]
var colorPresetsDict={
	skinTone={},
	eyesColor={},
	hairColor={},
	beardColor={}
}

var hairTones:Dictionary={
	black={
		rootColor="#000000",
		hairColor="#141414",
		tipColor="#2a2a2a"
	},
	dark_brown={
		rootColor="#1c0d04",
		hairColor="#5f3316",
		tipColor="#844c27"
	},
	light_brown={
		rootColor="#4b321c",
		hairColor="#ad6d34",
		tipColor="#eba769"
	},
	dark_blonde={
		rootColor="#432407",
		hairColor="#ffbf00",
		tipColor="#f0d386"
	},
	light_blonde={
		rootColor="#c9b27e",
		hairColor="#d7c58e",
		tipColor="#d1b66e"
	},
	dark_ginger={
		rootColor="#401e0f",
		hairColor="#872709",
		tipColor="#f24906"
	},		
	light_ginger={
		rootColor="#842a02",
		hairColor="#ff6e1f",
		tipColor="#ffa37f"
	},	
	grey={
		rootColor="#424242",
		hairColor="#888888",
		tipColor="#e2e2e2"
	},	
	white={
		rootColor="#787878",
		hairColor="#cccccc",
		tipColor="#ffffff"
	},		
}
var eyeTones:Dictionary={
	black={
		eyeColor1="#4b2609",
		eyeColor2="#270000"
	},
	dark_brown={
		eyeColor1="#813900",
		eyeColor2="#220a00"
	},
	medium_brown={
		eyeColor1="#936203",
		eyeColor2="#3c2f18"
	},
	light_brown={
		eyeColor1="#cc8202",
		eyeColor2="#395736"
	},
	dark_green={
		eyeColor1="#547200",
		eyeColor2="#093606"
	},
	light_green={
		eyeColor1="#90ee96",
		eyeColor2="#436340"
	},
	dark_blue={
		eyeColor1="#0ea1a8",
		eyeColor2="#002f3c"
	},	
	light_blue={
		eyeColor1="#a3f7fb",
		eyeColor2="#027291"
	},	
	grey={
		eyeColor1="#e1fafb",
		eyeColor2="#585d5f"
	},	
}
var skinTones:Dictionary={
	tone1={
		skinColor="#ffffff"
	},
	tone2={
		skinColor="#ddcdc0"
	},
	tone3={
		skinColor="#b5a190"
	},
	tone4={
		skinColor="#e1dbc7"
	},
	tone5={
		skinColor="#a7a087"
	},
	tone6={
		skinColor="#8f7f70"
	},
	tone7={
		skinColor="#947f65"
	},
	tone8={
		skinColor="#4f4032"
	},
	tone9={
		skinColor="#231306"
	},
}

func _ready():
	GameInstance.currentPlayer = character

	#- HAIR COLOUR PRESETS
	for bt in $Panel/vb/hair/vb/HairColorPresets.get_children():
		if bt.name!="random":
			var style:StyleBoxFlat = StyleBoxFlat.new()
			style.bg_color = hairTones[bt.name].hairColor
			bt.set("custom_styles/normal",style)
			bt.set("custom_styles/hover",style)
			bt.connect("pressed",self,"_presetButtonClicked",[bt.name,"hair"])
			colorPresetsDict.hairColor[bt.name]=bt
		else:
			bt.connect("pressed",self,"_randomHairColorClicked",["hair"])
	#- BEARD COLOUR PRESETS
	for bt in $Panel/vb/hair/vb2/BeardColorPresets.get_children():
		if bt.name!="random":
			var style:StyleBoxFlat = StyleBoxFlat.new()
			style.bg_color = hairTones[bt.name].hairColor
			bt.set("custom_styles/normal",style)
			bt.set("custom_styles/hover",style)
			bt.connect("pressed",self,"_presetButtonClicked",[bt.name,"beard"])
			colorPresetsDict.beardColor[bt.name]=bt
		else:
			bt.connect("pressed",self,"_randomHairColorClicked",["beard"])	
	
	
	#- EYES COLOUR PRESETS
	for bt in $Panel/vb/head/vb2/eyeColorPresets.get_children():
		if bt.name!="random":
			var style:StyleBoxFlat = StyleBoxFlat.new()	
			style.bg_color = eyeTones[bt.name].eyeColor1
			bt.set("custom_styles/normal",style)
			bt.set("custom_styles/hover",style)
			bt.connect("pressed",self,"_presetButtonClicked",[bt.name,"eyes"])	
			colorPresetsDict.eyesColor[bt.name]=bt
		else:
			bt.connect("pressed",self,"_randomEyesColorClicked")		

	#- SKIN TONE PRESETS
	for bt in $Panel/vb/body/vb/skinTonePresets.get_children():
		if bt.name!="random":
			var style:StyleBoxFlat = StyleBoxFlat.new()	
			style.bg_color = skinTones[bt.name].skinColor
			bt.set("custom_styles/normal",style)
			bt.set("custom_styles/hover",style)
			bt.connect("pressed",self,"_presetButtonClicked",[bt.name,"skin"])			
			colorPresetsDict.skinTone[bt.name]=bt
		else:
			bt.connect("pressed",self,"_randomSkinToneClicked")	

	#-PRESET BUTTONS
	for bt in $Panel/vb/presets/GridContainer.get_children():
		bt.connect("pressed",self,"_loadPreset",[bt.name])
		bt.texture_normal = ResourceLoader.load("res://Presets/"+bt.name+".png")
	
	
	#-OPEN THE PRESET PANEL FIRST
	$Panel/vb/bt_presets.emit_signal("pressed")
	
	#WAIT TO THE CHARACTER LOAD
	yield(get_tree(),"idle_frame")
	
	#-SET VIEWPORT SNAPSHOT TEXTURE
	$HB/vp.icon = character.faceViewport.get_texture()
	
	#-INIT FIRST DEFAULT PRESET
	$Panel/vb/presets/GridContainer/preset1.emit_signal("pressed")

	#-GET SLIDERS AND COLOR BUTTONS TO STORE IN THE ARRAYS
	_recursiveArrayGetter(self)
	
	_initValues()
	
func _initValues():
	#-VALUES INIT SO WE CAN INSERT NEW MODELS/MASK/TEXTURES AUTO-INITIALIZED OR CUSTOMIZED
	_initSlider($Panel/vb/hair/h_hairCut/slider,hairName.size()-1,1,0,"Haircut")
	_initSlider($Panel/vb/head/e_eyebrows/slider,eyebrowsName.size()-1,1,1,"Eyebrows Preset")
	_initSlider($Panel/vb/head/w_eyeBrowHeight/slider,0,0,0,"Eyebrows Height")	
	_initSlider($Panel/vb/head/p_facePaint/slider,facePaintName.size()-1,1,0,"Face Paint")
	_initSlider($Panel/vb/body/m_chubby/slider,1,0.01,0.5,"Body Shape")
	_initSlider($Panel/vb/hair/i_beard/slider,beardName.size()-1,1,0,"Beard Preset")
	_initSlider($Panel/vb/hair/vb/hb/vb3/k_tipOffset/slider,8,0.01,3,"Tip")
	_initSlider($Panel/vb/hair/vb/hb/vb/k_rootOffset/slider,8,0.01,3,"Root")
	_initSlider($Panel/vb/hair/vb2/hb/vb3/o_tipOffset/slider,6,0.01,2,"Tip")
	_initSlider($Panel/vb/hair/vb2/hb/vb/o_rootOffset/slider,6,0.01,2,"Root")
	_initSlider($Panel/vb/hair/c_beardLength/slider,1,0.009,0.5,"Beard Length")
	_initSlider($Panel/vb/head/d_beard/slider,subBeard.size()-1,1,0,"Sub Beard")
	_initSlider($Panel/vb/hair/b_hairLength/slider,1,0.01,0,"Hair Length")
	_initSlider($Panel/vb/head/a_asymmetry/slider,2,1,0,"Asymmetry")
	#-Init preset buttons
	$Panel/vb/hair/vb/HairColorPresets/dark_brown.emit_signal("pressed")
	$Panel/vb/head/vb2/eyeColorPresets/medium_brown.emit_signal("pressed")
	$Panel/vb/hair/vb/HairColorPresets/black.emit_signal("pressed")
	$Panel/vb/hair/vb2/BeardColorPresets/black.emit_signal("pressed")
	
func _initSlider(slider:HSlider,size:int,step:float,value,name):
	if name=="Eyebrows Height":
		slider.min_value=-5.1
		slider.max_value=-4.9
		slider.tick_count=1
		slider.value=-5
	else:
		slider.max_value=size
		slider.tick_count=size+1
		slider.step=step
		slider.value=value
	slider.get_parent().get_child(0).text = name
	
func _randomHairColorClicked(type:String):
	randomize()
	var col1:Color = Color(rand_range(0,0.3),rand_range(0,0.3),rand_range(0,0.3))
	var col2:Color = Color(rand_range(0,0.6),rand_range(0,0.6),rand_range(0,0.6))
	var col3:Color = Color(rand_range(0.5,1),rand_range(0.5,1),rand_range(0.5,1))
	if type=="hair":
		character._setMaterialParameter("rootColor","hair",col1)
		character._setMaterialParameter("hairColor","hair",col2)
		character._setMaterialParameter("tipColor","hair",col3)
		$Panel/vb/hair/vb/hb/vb/rootColor_hair.color = col1
		$Panel/vb/hair/vb/hb/vb2/hairColor_hair.color = col2
		$Panel/vb/hair/vb/hb/vb3/tipColor_hair.color = col3
	elif type=="beard":
		character._setMaterialParameter("rootColor","beard",col1)
		character._setMaterialParameter("hairColor","beard",col2)
		character._setMaterialParameter("tipColor","beard",col3)	
		$Panel/vb/hair/vb2/hb/vb/rootColor_beard.color = col1
		$Panel/vb/hair/vb2/hb/vb2/hairColor_beard.color = col2
		$Panel/vb/hair/vb2/hb/vb3/tipColor_beard.color = col3	
		
func _randomEyesColorClicked():	
	randomize()
	var col1:Color = Color(rand_range(0.5,1),rand_range(0.5,1),rand_range(0.5,1))
	var col2:Color = Color(rand_range(0,0.2),rand_range(0,0.2),rand_range(0,0.2))
	$Panel/vb/head/vb2/eyeColor1_eyes.color = col1
	$Panel/vb/head/vb2/eyeColor2_eyes.color = col2
	character._setMaterialParameter("eyeColor1","eyes",col1)
	character._setMaterialParameter("eyeColor2","eyes",col2)

func _randomSkinToneClicked():
	randomize()
	var vmin = 0.6
	var col:Color = Color(rand_range(vmin,1),rand_range(vmin,1),rand_range(vmin,1))
	$Panel/vb/body/vb/skinTone_body.color = col
	character._setSkinColor(col)
	
func _presetButtonClicked(bt:String,type:String):
	if type=="hair":
		character._setMaterialParameter("rootColor","hair",Color(hairTones[bt].rootColor))
		character._setMaterialParameter("hairColor","hair",Color(hairTones[bt].hairColor))
		character._setMaterialParameter("tipColor","hair",Color(hairTones[bt].tipColor))
		$Panel/vb/hair/vb/hb/vb/rootColor_hair.color = hairTones[bt].rootColor
		$Panel/vb/hair/vb/hb/vb2/hairColor_hair.color = hairTones[bt].hairColor
		$Panel/vb/hair/vb/hb/vb3/tipColor_hair.color = hairTones[bt].tipColor
	if type=="beard":
		character._setMaterialParameter("rootColor","beard",Color(hairTones[bt].rootColor))
		character._setMaterialParameter("hairColor","beard",Color(hairTones[bt].hairColor))
		character._setMaterialParameter("tipColor","beard",Color(hairTones[bt].tipColor))
		$Panel/vb/hair/vb2/hb/vb/rootColor_beard.color = hairTones[bt].rootColor
		$Panel/vb/hair/vb2/hb/vb2/hairColor_beard.color = hairTones[bt].hairColor
		$Panel/vb/hair/vb2/hb/vb3/tipColor_beard.color = hairTones[bt].tipColor
	if type=="eyes":
		$Panel/vb/head/vb2/eyeColor1_eyes.color=eyeTones[bt].eyeColor1
		$Panel/vb/head/vb2/eyeColor2_eyes.color=eyeTones[bt].eyeColor2
		character._setMaterialParameter("eyeColor1","eyes",Color(eyeTones[bt].eyeColor1))
		character._setMaterialParameter("eyeColor2","eyes",Color(eyeTones[bt].eyeColor2))
	if type=="skin":
		$Panel/vb/body/vb/skinTone_body.color = skinTones[bt].skinColor
		character._setSkinColor(Color(skinTones[bt].skinColor))

func _colorPickerChanged(param:String,mat:String,col:Color):
	
	if mat=="body":
		character._setSkinColor(col)
	else:
		character._setMaterialParameter(param,mat,col)

func _process(delta):
	$Label2.text = str(Engine.get_frames_per_second())
func _sliderChange(v,type,prop):
	match type:
		"m":
			character._setChubbiness(v)
		"b":
			character._setBlendShape("hair","length",v)
		"c":
			character._setBlendShape("beard","length",v)
		"h":
			character._setMesh("hair",v)
			$Panel/vb/hair/h_hairCut/sLabel.text = hairName[v]
		"i":
			character._setMesh("beard",v)
			$Panel/vb/hair/i_beard/sLabel.text=beardName[v]
		"d":
			character._setParameterTexture(v,"head",prop)
			$Panel/vb/head/d_beard/sLabel.text=subBeard[v]
		"e":
			character._setParameterTexture(v,"head",prop)
			$Panel/vb/head/e_eyebrows/sLabel.text=eyebrowsName[v]
		"w":
			character._setMaterialParameter(prop,"head",v)	
		"p":
			character._setParameterTexture(v,"head",prop)
		"k":
			character._setMaterialParameter(prop,"hair",v)
		"o":
			character._setMaterialParameter(prop,"beard",v)
		"a":
			if v==1:
				character.head.set("blend_shapes/asymmetry1",1)
				character.head.set("blend_shapes/asymmetry2",0)
			elif v==2:
				character.head.set("blend_shapes/asymmetry1",0)
				character.head.set("blend_shapes/asymmetry2",1)
			else:
				character.head.set("blend_shapes/asymmetry1",0)
				character.head.set("blend_shapes/asymmetry2",0)

func _recursiveArrayGetter(node):
	for n in node.get_children():
		if n.get_child_count()>0:
			_recursiveArrayGetter(n)
		else:
			if n.is_class("ColorPickerButton"):
				colorPresetsArray.append(n)
			if n.is_class("HSlider"):
				slidersArray.append(n)

func _on_savePreset_pressed():

	character._saveBlendShapes()
	character._saveBones()
	for s in slidersArray:
		character.preset.sliders[s.get_parent().name] = s.value
	for s in colorPresetsArray:
		character.preset.colorPresets[s.name]= s.color.to_html()
	Save._savePreset($HB/VB/nameText.text,character.preset)
	_snapshot()
	
	
func _loadPreset(n:String):
	var data:Dictionary = Save._loadPreset(n)
	character._load(data)	
	for s in slidersArray:
		s.value = data.sliders[s.get_parent().name]	
	for c in colorPresetsArray:
		c.color = data.colorPresets[c.name]
		c.emit_signal("color_changed",data.colorPresets[c.name])


func _on_randomButton_pressed():
	$Randomizer._randomize()


func _snapshot():
	var img:Image=character.faceViewport.get_texture().get_data()
	img.save_png("res://Presets/"+$HB/VB/nameText.text+".png")
	


func _on_saveCharacter_pressed():
	character._saveCharacterData()
	GameInstance._changeScene("res://World/Levels/MainMenu.tscn")
	


func _on_nameText_text_changed(new_text):
	character.characterData["name"]=new_text
