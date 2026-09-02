extends Camera2D

@onready var player: CharacterBody2D = $".."
@onready var timer: Timer = $Timer
@onready var tween: Tween = create_tween()

var mov_rate_y: float = 0.01

var shake_amount: float = 0
var defualt_offset: Vector2 = offset
var pos_x : int
var pos_y : int


func _ready() -> void:
	set_process(true)
	Global.camera = self
	randomize()


func _process(_delta: float) -> void:
	if player.grav_direction == 1:
		offset.y = lerp(offset.y, -75.0, mov_rate_y)
	else:
		offset.y = lerp(offset.y, 75.0, mov_rate_y)
	
	offset = Vector2(randf_range(-1, 1) * shake_amount, randf_range(-1, 1) * shake_amount)


func shake(time: float, shake: float):
	timer.wait_time = time
	shake_amount = shake
	set_process(true)
	timer.start()


func _on_timer_timeout() -> void:
	set_process(false)
	tween.interpolate_value(self, "offset", 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
