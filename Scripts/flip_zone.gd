extends Area2D

@onready var flip_timer: Timer = $Timer
@onready var player: CharacterBody2D = $"../Player"

func _on_body_entered(_body: Node2D) -> void:
	flip_timer.start()


func _on_timer_timeout() -> void:
	player.grav_direction *= -1.0
 
