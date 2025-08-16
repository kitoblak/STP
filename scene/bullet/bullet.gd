extends Area2D

@export var speed: int

var direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		
		global_position += velocity
	

func set_direction(direction: Vector2):
	self.direction = direction
	rotation += direction.angle()


func _on_area_entered(area):
	queue_free()
