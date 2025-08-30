extends CharacterBody2D

@export var max_sped: int = 1200
@export var run_add: int = 600
@export var run_stamina_usage: float = 5
@export var stamina_regen: float = 5
@export var bullet: PackedScene
@export var rotation_speed: float = 5.0
@export var acceleration:float = 0.1
@export var fire_rate: float = 0.2

var can_shoot: bool = true
var fire_timer: float = 0.0
var fire_button_pressed: bool = false
var HealthBar
var StaminaBar
var could_run: int = 0
var stamina_spent: bool = false

@onready var end_of_gun = $EndOfGun
@onready var bullet_manager = get_parent().get_node("Bullet_Manager")

# Called when the node enters the scene tree for the first time.
func _ready():
	#player_stopped_firing.connect(bullet_manager.stop_firing)
	Global.stamina_spent.connect(stamina_stop)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	var dvizh = detect_movement_vector()
	var target_velocity = (max_sped + run_add * could_run) * dvizh
	velocity = velocity.lerp(target_velocity, acceleration)
	move_and_slide()
	
	krutit(delta)
	
	if (could_run and target_velocity != Vector2(0, 0)):
		Global.update_stamina.emit(-run_stamina_usage * delta)
	else:
		Global.update_stamina.emit(stamina_regen * delta)

func krutit(delta):
	var target_position = get_global_mouse_position()
	var target_rotation = (target_position - global_position).angle()

	rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)

func detect_movement_vector():
	var kuda_x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var kuda_y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	return Vector2(kuda_x, kuda_y).normalized()

func _unhandled_input(event):
	if (event.is_action_pressed("lmb")):
		shoot()
	if (event.is_action_pressed("Run")):
		could_run = 1
	if (event.is_action_released("Run")):
		could_run = 0
	if (event.is_action_pressed("ability_1")):
		Global.state_add.emit(0)
	if (event.is_action_pressed("ability_2")):
		Global.state_add.emit(1)
	if (event.is_action_pressed("ability_3")):
		Global.state_add.emit(2)
	#if (event.is_action_released("lmb")):
		#stop_shoot()

func shoot():
	var bullet_instance = bullet.instantiate()
	var target = end_of_gun.global_position
	var direction_to_mouse = (target - global_position).normalized()
	Global.player_fired_bullet.emit(1, end_of_gun.global_position, direction_to_mouse)

func stamina_stop():
	could_run = 0

#func stop_shoot():
	#player_stopped_firing.emit()
	
