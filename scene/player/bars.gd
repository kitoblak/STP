extends CanvasLayer

var StaminaBar

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.update_stamina.connect(update_stamina)
	StaminaBar = get_node("Stamina")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_stamina(delta_value):
	var current_stamina = StaminaBar.value + delta_value
	StaminaBar.value = clampf(current_stamina, 0, 100)
	if (StaminaBar.value == 0.0):
		Global.stamina_spent.emit()
