extends CharacterBody2D

enum STATE { MOVE, OFF_BOUND }

@export var extra_ledg_time: = 2
@export var falling_time: = 0
@export var state: = STATE.MOVE
@export var max_speed: = 120
@export var acceleration: = 1000.0
@export var air_acceleration: = 1000.0
@export var friction: = 1000.0
@export var air_friction: = 500.0
@export var up_gravity: = 500.0
@export var down_gravity: = 500.0
@export var jump_gravity: = 600.0
@export var jump_ammount: = 300.0

# O player que vai executar nossas animações conforme formos o acionando
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var anchor: Node2D = $Anchor
@onready var camera_2d: Camera2D = $Camera2D
@onready var jump_effect: AudioStreamPlayer2D = $JumpEffect

signal coined()
signal died()

# That is the basic function wich will be runing each delta
# Delta stands for the fps counting
func _physics_process(delta: float) -> void:
	match state:
		STATE.MOVE: 
			extra_ledg_time -= delta
			
			print(get_position_delta())
			
			if(!is_on_floor() and get_position_delta().y >= 15):
				state = STATE.OFF_BOUND
						
			# Retrieves the direction wich the physcis will be applied
			var x_input = Input.get_axis("move_left", "move_right")
			
			if x_input != 0.0:
				accelerate_horizontally(x_input, delta)
			else:
				apply_friction(delta)
			
			if not is_on_floor():
				velocity.y += up_gravity * delta
			
			if Input.is_action_just_pressed("jump"):
				jump_effect.play()
			
			if Input.is_action_just_pressed("jump") and is_on_floor() or extra_ledg_time > 0:
				velocity.y -= jump_ammount
			
			# its a physics variable wich can determine the ammount of force
			# applied to an object to move
			velocity.x = x_input * max_speed
			
			if x_input != 0:
				anchor.scale.x = sign(x_input)
				animation_player.play('run')
			else:
				# sign takes a value and returns it negative one or one if its positive, and 0 if its 0!
				animation_player.play('stand')
			if not is_on_floor():
				animation_player.play("jump")
			
			var was_on_floor: = is_on_floor()
			# Tenders the speed, to other variables and move the object
			# move n slide alreadyt aplis delta to the velocity so 
			# we don't need to apply it to it
			# however when we add velocity here we are changing the acceleration! And 
			# In physics, its the value of accelaration that changes velocity so 
			# goto line 12
			# and by doing so we're adding gravity to our world
			move_and_slide()	
			# Not on floor and velocity is down
			if was_on_floor and not is_on_floor() and velocity.y >= 0:
				extra_ledg_time = 0.2
				
		STATE.OFF_BOUND:
			falling_time+= 1
			if(falling_time >= 50):
				die()
			else:
				STATE.MOVE
		

func accelerate_horizontally(horizontal_direction: float, delta: float) -> void:
	var acceleration_ammount: = acceleration 
	if not is_on_floor(): acceleration_ammount = air_acceleration
	velocity.x = move_toward(velocity.x, max_speed * horizontal_direction, acceleration_ammount * delta * abs(horizontal_direction) )

func apply_friction(delta) -> void :
	var friction_ammount: = friction
	if not is_on_floor(): friction_ammount = air_friction
	velocity.x = move_toward(velocity.x, 0.0, friction_ammount * delta)
	
func apply_gravity(delta) -> void:
	if not is_on_floor() and velocity.y <= 0:
		velocity.y += up_gravity * delta
			

func die():
	camera_2d.reparent(get_tree().current_scene)
	queue_free()
	died.emit()
	

func _on_area_2d_area_entered(_area: Area2D) -> void:
	coined.emit()
