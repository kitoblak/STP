extends CharacterBody2D

var max_sped = 600

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	var direction = kak_proyti_k_igroku(player)
	velocity = max_sped * direction
	move_and_slide()

func kak_proyti_k_igroku(player: Node2D):
	if player != null:
		look_at(player.global_position)
		return (player.global_position - self.global_position).normalized()
	return Vector2.ZERO
