extends Control
var event
var sentences : Array[Array]
var theDay : String
var temperature : String
var sentences_warn : Array[Array]

@onready var chat_text: chatText = $chatText
@onready var weather_api: HTTPRequest = $WeatherApi
@onready var character: Character = $character
@onready var menu = get_node("menu")

func _ready() -> void:
	get_tree().root.set_transparent_background(true)
	_requsetWheather()
	menu.hide()
	sentences = [
		["你好，我叫阿梨","Speaking"],#自我介绍
		["鼠标左键移动\n右键互动","Speaking"],#介绍操作
		["不要总点啊，\n要好好工作哦","Speaking"],#提醒不要乱点
		["按E打开菜单\n按Q退出菜单","Speaking"], #说明菜单
		["你今天吃了啥","Speaking"],
		["从前有座山\n山上有座庙...","Speaking"],
		["你知道吗\n两个人相爱的概率是\n0.000049","Speaking"],
		["春眠不知晓\n处处蚊子咬","Speaking"],
		["要记得好好的\n爱自己哦","Speaking"],
		["每天最大的笑话：\n今天要早睡，明天要早起","Speaking"],
		["曼波，曼波，\n欧马几里曼波","Speaking"],
		["好想找事做啊","Speaking"],
		["俺来自东土大唐...","Speaking"],
		["阿巴阿巴","Speaking"],
		["君子一言，\n驷马难追","Speaking"],
		["","Speaking"]#播报天气
		]
		
	sentences_warn = [
	["记得喝水哦","drink_please"],
	["你已经工作\n一个小时了，该出去走走，\n放松自己的眼睛了","walk_please"],
	["加油哦！\n你已经很棒了！","save_please"]
	]



func _on_character_chat() -> void: #随机播放对话
	var index :int = randi_range(0, 15)
	chat_text.text = sentences[index][0]
	character.animation_player.play(sentences[index][1])
	chat_text._play_chat()


func _requsetWheather() -> void: #获取天气的api
	weather_api.request("https://api.seniverse.com/v3/weather/now.json?key=SDK-wPu4027VMD7am&location=xiangtan&language=zh-Hans&unit=c")


func _on_weather_api_request_completed(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json :=JSON.parse_string(body.get_string_from_utf8()) as Dictionary
	theDay = json.results[0].now.text as String
	temperature = json.results[0].now.temperature as String
	sentences[15][0] = "今天湘潭的天气" + theDay + ",\n温度是" + temperature +"摄氏度" #实现播报天气的方法


func _on_weather_request_timer_timeout() -> void: #每一分钟获取天气
	_requsetWheather()


func _on_character_chat_warn() -> void: #判断三种状态，并执行
	if character.drinkFlag:
		chat_text.text = sentences_warn[0][0]
		character.animation_player.play(sentences_warn[0][1])
		chat_text._play_chat()
		character.drink_time.start()
		character.drinkFlag = false
		return
	if character.walkFlag:
		chat_text.text = sentences_warn[1][0]
		character.animation_player.play(sentences_warn[1][1])
		chat_text._play_chat()
		character.walk_time.start()
		character.walkFlag = false
		return
	if character.saveFlag:
		chat_text.text = sentences_warn[2][0]
		character.animation_player.play(sentences_warn[2][1])
		chat_text._play_chat()
		character.save_time.start()
		character.saveFlag = false
		return


func _physics_process(_delta: float) -> void: #菜单的方式
	if Input.is_action_just_pressed("menu"):
		menu.show()
	elif Input.is_action_just_pressed("menu_quit"):
		menu.hide()
	else :
		pass
