extends StaticBody2D

@onready var player: CharacterBody2D = $"../../Player"
@onready var area_2d: Area2D = $Area2D



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		player.kill()
