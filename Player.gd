extends CharacterBody2D

@export var move_speed = 200.0
@export var jump_height = 100.0
@export var jump_time_to_peak = 0.3
@export var jump_time_to_descent = 0.25

@onready var jump_velocity = -(2.0 * jump_height) / jump_time_to_peak
@onready var jump_gravity = -(2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity = -(2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)

var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= get_gravity() * delta
	
	velocity.x = 0
	if Input.is_action_pressed("move_right"):
		velocity.x += move_speed
	if Input.is_action_pressed("move_left"):
		velocity.x -= move_speed
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	move_and_slide()
	animate()

func get_gravity():
	return jump_gravity if velocity.y < 0 else fall_gravity

func animate():
	if velocity.y < 0:
		$AnimatedSprite2D.play("jump")
	elif velocity.y > 0:
		$AnimatedSprite2D.play("fall")
	elif velocity.x != 0:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")
	$AnimatedSprite2D.flip_h = velocity.x < 0
