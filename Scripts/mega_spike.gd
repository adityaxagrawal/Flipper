extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var particles: CPUParticles2D = $Explosion/CPUParticles2D
@onready var death_timer: Timer = $DeathTimer
@onready var player: CharacterBody2D = $"../../Player"
@onready var col_shape: CollisionPolygon2D = $Area2D/CollisionPolygon2D

const steer_force: float = 1
const speed: float = 260.0

var homing: bool = false
var rotation_offset: float = 0.0


func _ready() -> void:
	rotation_offset = sprite.global_rotation - Vector2.DOWN.angle()
	particles.amount = 300
	
	
func _physics_process(_delta: float) -> void:
	
	if homing:
		var direction = (player.global_position - global_position).normalized()
		velocity = velocity.lerp(direction * speed, steer_force)
		
	if velocity.length() > 0:
		sprite.rotation = velocity.angle() + rotation_offset
		
	move_and_slide()


func _on_area_2d_2_body_entered(_body: Node2D) -> void:
	homing = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	explode()
	if body == player:
		player.kill()


func explode() -> void:
	particles.emitting = true
	sprite.hide()
	col_shape.set_deferred("disabled", true)
	death_timer.start()
	Global.camera.shake(0.4, 30.0)
	
	
func _on_death_timer_timeout() -> void:
	queue_free()
