extends Node2D
class_name  Character
@onready var collision_polygon_2d: CollisionPolygon2D = $Portrait/Area2D/CollisionPolygon2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Portrait/Area2D
@onready var drink_time: Timer = $drinkTime
@onready var walk_time: Timer = $walkTime
@onready var save_time: Timer = $saveTime
@onready var warn_voice: AudioStreamPlayer = $warn_voice

signal chat 
signal chat_warn

var speakingFlag :bool = false
var drinkFlag :bool = false
var walkFlag :bool = false
var saveFlag :bool = false
var can_drag: bool
var mouse_position: Vector2i
var idle_play := ["idle"]

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.pressed: #判断是否按下
					can_drag = true
					mouse_position = get_global_mouse_position() #获取当前鼠标位置
				else:
					can_drag = false
		if can_drag and event is InputEventMouseMotion:
			DisplayServer.window_set_position(DisplayServer.mouse_get_position() - mouse_position) #鼠标位置 - 偏值
		if event.is_action_pressed("chatset"):
			chat.emit()
			speakingFlag = true


enum State{
	IDLE = 0,
	SPEAKING,
	WARN,
} #枚举三种状态，空闲，说话，提醒

var current_state := State.IDLE #设置当前状态处于空闲
var next_state :int = -1

func get_next_state() -> int:
	match current_state:
		State.IDLE:
			if speakingFlag: #如果是说话，执行说话
				return State.SPEAKING
			
			if !game_Manager.text_showing and (drinkFlag or walkFlag or saveFlag): #如果是三种状态，执行提醒，设置一个判断文字存在的布尔值
				return State.WARN
		State.SPEAKING:
			if (!animation_player.is_playing()): #如果播放动画，执行说话，反之
				speakingFlag =false
				return State.IDLE
				
		State.WARN:
			if (!animation_player.is_playing()):
				return State.IDLE
	return -1


func goto_new_state() -> void: #前往下一个状态的函数，来判断进入某种状态
	match current_state:
		State.IDLE:
			area_2d.input_pickable = true
		State.SPEAKING:
			game_Manager.text_showing = true 
		State.WARN:
			chat_warn.emit()
			game_Manager.text_showing = true
			area_2d.input_pickable = false


func do_current_state() -> void:
	match current_state:
		State.IDLE:
			if (!animation_player.is_playing()):
				animation_player.play(idle_play.pick_random()) #播放待机动画
		State.SPEAKING:
			pass
		State.WARN:
			pass

func _on_drink_time_timeout() -> void: #每30分钟提醒喝水
	drinkFlag = true


func _on_walk_time_timeout() -> void: #每60分钟提醒走动
	walkFlag = true
	warn_voice.play()


func _on_save_time_timeout() -> void: #每20分钟提醒鼓励
	saveFlag =true


func _physics_process(_delta: float) -> void: #自动每一秒执行一次方法
		next_state =get_next_state() #get_next_state()返回一个State里的值给next_state，如果不需要的话返回-1
		if  next_state != -1:
			@warning_ignore("int_as_enum_without_cast")
			current_state = next_state #返回的不是-1的话，说明需要切换状态了，把next_state赋值给curren_state，然后再执行goto_new_state()
			goto_new_state()
		do_current_state()

