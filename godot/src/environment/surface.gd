class_name Surface extends Area2D


var has_mouse:=false

@export var id: Types.SurfaceId


func _on_mouse_entered() -> void:
	has_mouse=true


func _on_mouse_exited() -> void:
	has_mouse=false
