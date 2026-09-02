extends Area2D

@onready var player: CharacterBody2D = $"../Player"

var last_location: Vector2

func _ready() -> void:
	last_location = player.global_position

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		Global.last_location = player.global_position
