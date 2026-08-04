class_name FishingSpot
extends StaticBody2D

@onready var fishing_delay_timer: Timer = $FishingDelayTimer

signal free_seal
var is_used: bool
@export var tick_left: int = 10:
	set(value):
		if value <= 0:
			free_seal.emit()
			queue_free()
		else:
			tick_left = value

@export var fish_per_tick: int = 1


func _start_fishing() -> void:
	fishing_delay_timer.start()

func _on_timer_timeout() -> void:
	tick_left -= 1
	Utility.amount_fish += fish_per_tick
