extends CharacterBody2D


const SPEED: float = 210.0  # 210.0
const JUMP_VELOCITY: float = -450.0  # -450.0
const DECELERATION: float = 0.3  # 0.22
const ACCELERATION: float = 0.4  # 0.4

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var sprite: Polygon2D = $Polygon2D
@onready var col_shape: CollisionShape2D = $CollisionShape2D
@onready var kill_timer: Timer = $KillTimer
@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var checkpoints: Area2D = $"../Checkpoints"

var can_jump: bool = false
var has_jumped: bool = false
var jump_buffer: bool = false
var has_landed: bool = false
var killed: bool = false

var grav_direction: float = 1.0


func _ready() -> void:
	can_jump = false
	has_jumped = false
	jump_buffer = false
	has_landed = false
	killed = false
	
	grav_direction = 1.0
	
	global_position = Global.last_location


func _physics_process(delta: float) -> void:
	if not killed:
		# Handle gravity
		velocity += get_gravity() * delta * 2 * grav_direction

		# Handle jump
		var was_on_floor = is_on_floor() or is_on_ceiling()
		move_and_slide()
		
		if (is_on_floor() or is_on_ceiling()) and not was_on_floor and not has_landed:
			has_landed = true
			landed()
		
		if was_on_floor and not is_on_floor() and not is_on_ceiling() and not has_jumped:
			can_jump = true
			coyote_timer.start()
		
		if is_on_floor() or is_on_ceiling():
			can_jump = true
			has_jumped = false
			
			if jump_buffer:
				jump()
				jump_buffer = false
		else:
			has_landed = false
		
		if has_jumped:
			can_jump = false
			
		if Input.is_action_just_pressed("Jump"):
			if can_jump:
				jump()
				
			elif has_jumped:
				jump_buffer = true
				jump_buffer_timer.start()
				

		# Get the input direction and handle the acceleration/deceleration.
		var direction := Input.get_axis("Left", "Right")
		if direction:
			velocity.x = lerp(velocity.x, SPEED * direction, ACCELERATION)
		elif velocity.x:
			velocity.x = lerp(velocity.x, 0.0, DECELERATION)
		
		velocity.y = clamp(velocity.y, JUMP_VELOCITY, -JUMP_VELOCITY)
		


func jump():
	squash_stretch(Vector2(0.8, 1.2))
	velocity.y = JUMP_VELOCITY * grav_direction
	has_jumped = true
	
	
func landed():
	squash_stretch(Vector2(1.1, 0.9))
	await get_tree().create_timer(0.15).timeout
	squash_stretch(Vector2(1, 1))


func _on_coyote_timer_timeout() -> void:
	can_jump = false


func _on_jump_buffer_timer_timeout() -> void:
	jump_buffer = false
	

func squash_stretch(scale_factor: Vector2, duration : float = 0.1):
	var tween = create_tween()
	tween.tween_property(self, "scale", scale_factor, duration).set_trans(Tween.TRANS_QUAD)
	
	
func kill():
	particles.emitting = true
	sprite.hide()
	col_shape.set_deferred("disabled", true)
	Global.camera.shake(0.2, 3.0)
	kill_timer.start()
	killed = true


func _on_kill_timer_timeout() -> void:
	get_tree().reload_current_scene()
