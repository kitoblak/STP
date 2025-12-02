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
	
	HealthBar.scale.x = get_parent().ZOOM * 3
	HealthBar.scale.y = get_parent().ZOOM * 3
	
	StaminaBar.scale.x = get_parent().ZOOM * 3
	StaminaBar.scale.y = get_parent().ZOOM * 3
	
	HealthBar.position.x = get_viewport().get_visible_rect().size.x * 0.97 - HealthBar.size.x * HealthBar.scale.x
	HealthBar.position.y = get_viewport().get_visible_rect().size.y * 0.97 - HealthBar.size.y * HealthBar.scale.y - HealthBar.size.y * HealthBar.scale.y
	
	StaminaBar.position.x = get_viewport().get_visible_rect().size.x * 0.97 - StaminaBar.size.x * StaminaBar.scale.y
	StaminaBar.position.y = get_viewport().get_visible_rect().size.y * 0.97 - StaminaBar.size.y * StaminaBar.scale.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_stamina(delta_value):
	var current_stamina = StaminaBar.value + delta_value
	StaminaBar.value = clampf(current_stamina, 0, 100)
	if (StaminaBar.value == 0.0):
		Global.stamina_spent.emit()
