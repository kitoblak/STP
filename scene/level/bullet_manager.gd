extends Node2D

@export var bullet: PackedScene
@export var fire_rate: float = 0.2

@onready var timer: Timer = Timer.new()
@onready var type: int
@onready var pos: Vector2
@onready var direct: Vector2

func _ready():
	#timer.timeout.connect(_on_timer_timeout)
	Global.player_fired_bullet.connect(handle_bullet_spawned)

#func start_timer():
	#add_child(timer)
	#timer.start(fire_rate)

func handle_bullet_spawned(type, position, direction):
	#start_timer()
	#pos = position
	#direct = direction
	var bullet = bullet.instantiate()
	add_child(bullet)
	bullet.global_position = position
	bullet.set_direction(direction)

#func _on_timer_timeout():
	#var bullet = bullet.instantiate()
	#add_child(bullet)
	#bullet.global_position = pos
	#bullet.set_direction(direct)
#
#func stop_firing():
	#timer.stop()
