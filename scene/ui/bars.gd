extends Control

@export var max_health := 100
@export var max_stamina := 100
@export var max_radiation := 100

var StaminaBar
var HealthBar
var RadiationBar

var radiation: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.update_stamina.connect(update_stamina)
	StaminaBar = get_node("Stamina")
	HealthBar = get_node("Health")
	RadiationBar = get_node("Radiation")
	
	HealthBar.max_value = max_health
	HealthBar.value = max_health
	
	StaminaBar.max_value = max_stamina
	StaminaBar.value = max_stamina
	
	RadiationBar.max_value = max_radiation
	RadiationBar.value = 0
	
	HealthBar.scale.x = get_parent().ZOOM * 3
	HealthBar.scale.y = get_parent().ZOOM * 3
	
	StaminaBar.scale.x = get_parent().ZOOM * 3
	StaminaBar.scale.y = get_parent().ZOOM * 3
	
	RadiationBar.scale.x = get_parent().ZOOM * 3
	RadiationBar.scale.y = get_parent().ZOOM * 3
	
	RadiationBar.position.x = get_viewport().get_visible_rect().size.x * 0.97 - RadiationBar.size.x * RadiationBar.scale.x
	RadiationBar.position.y = get_viewport().get_visible_rect().size.y * 0.97 - RadiationBar.size.y * RadiationBar.scale.y * 2 - RadiationBar.size.y * RadiationBar.scale.y
	
	HealthBar.position.x = get_viewport().get_visible_rect().size.x * 0.97 - HealthBar.size.x * HealthBar.scale.x
	HealthBar.position.y = get_viewport().get_visible_rect().size.y * 0.97 - HealthBar.size.y * HealthBar.scale.y - HealthBar.size.y * HealthBar.scale.y
	
	StaminaBar.position.x = get_viewport().get_visible_rect().size.x * 0.97 - StaminaBar.size.x * StaminaBar.scale.y
	StaminaBar.position.y = get_viewport().get_visible_rect().size.y * 0.97 - StaminaBar.size.y * StaminaBar.scale.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (RadiationBar.value > 90 and radiation == 1):
		radiation *= -1
	elif (RadiationBar.value < 10 and radiation == -1):
		radiation *= -1
	RadiationBar.value = RadiationBar.value + radiation * delta

func update_stamina(delta_value):
	var current_stamina = StaminaBar.value + delta_value
	StaminaBar.value = clampf(current_stamina, 0, 100)
	if (StaminaBar.value == 0.0):
		Global.stamina_spent.emit()
