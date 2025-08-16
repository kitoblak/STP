extends Control

@export var max_health := 100
@export var max_stamina := 100

var StaminaBar
var HealthBar

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.update_stamina.connect(update_stamina)
	StaminaBar = get_node("Stamina")
	HealthBar = get_node("Health")
	
	HealthBar.max_value = max_health
	HealthBar.value = max_health
	
	StaminaBar.max_value = max_stamina
	StaminaBar.value = max_stamina

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_stamina(delta_value):
	var current_stamina = StaminaBar.value + delta_value
	StaminaBar.value = clampf(current_stamina, 0, 100)
	if (StaminaBar.value == 0.0):
		Global.stamina_spent.emit()
