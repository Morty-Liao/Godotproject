class_name Screen_tap_effects extends Control

@onready var graphics = $graphics
@onready var particle = $graphics/particle

#检测鼠标的行为
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event. button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				var a = graphics.duplicate() #复制该节点，返回一个新的节点
				var b = particle.duplicate()
				self.add_child(a)
				a.add_child(b)
				a.global_position = event.global_position
				a.emitting = true
				b.emitting = true
				a.connect("finished",_on_finished.bind(a))

func _on_finished(a):
	a.queue_free()
