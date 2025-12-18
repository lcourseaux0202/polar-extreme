extends Control
class_name NotificationIndicator
@onready var label := $NumberLabel

func setVisible(visible : bool):
	self.visible =visible

func increament_number():
	label.text=int(label.text)+1
