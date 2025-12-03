extends Node

signal player_fired_bullet(type, position, direction)
signal player_stopped_firing
signal update_stamina(delta_value)
signal update_health(delta_value)
signal stamina_spent
signal state_add(state_type: int)
signal state_remove(state_type: int)
signal InventoryToggle


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
