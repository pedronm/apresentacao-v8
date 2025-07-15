extends CharacterBody2D

# O player que vai executar nossas animações conforme formos o acionando
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# That is the basic function wich will be runing each delta
# Delta stands for the fps counting
func _physics_process(delta: float) -> void:
	# Retrieves the direction wich the physcis will be applied
	var x_input = Input.get_axis("ui_left", "ui_right")
	
	# its a physics variable wich can determine the ammount of force
	# applied to an object to move
	velocity.x = x_input * 50
	
	if x_input != 0:
		animation_player.play('run')
	else :
		animation_player.play('stand')
	# Tenders the speed, to other variables and move the object
	move_and_slide()	
