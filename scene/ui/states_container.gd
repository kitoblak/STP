# Состояния.gd (скрипт для CanvasLayer)
extends Control

# Узлы
#@onready var states_container = $StatesContainer

# Константы
const MAX_STATES_PER_ROW = 3
const STATE_SIZE = Vector2(256, 256)
const HORIZONTAL_SPACING = 10
const VERTICAL_SPACING = 10

# Структура для хранения информации о состоянии
class StateInfo:
	var sprite: Sprite2D
	var timer: Timer
	var state_type: int
	var duration: float
	
	func _init(p_state_type: int, p_duration: float, p_texture: Texture2D):
		state_type = p_state_type
		duration = p_duration
		
		# Создаем спрайт
		sprite = Sprite2D.new()
		sprite.texture = p_texture
		sprite.centered = false
		
		# Создаем таймер
		timer = Timer.new()
		timer.wait_time = p_duration
		timer.one_shot = true

# Текстуры для состояний (назначаются в инспекторе)
@export var state_textures: Array[Texture2D] = []

# Время действия для каждого состояния по умолчанию
@export var durations: Array[float] = []

# Массив текущих активных состояний
var active_states: Array[StateInfo] = []

# Сигналы для добавления состояний
#signal state_added(state_type: int)
#signal state_removed(state_type: int)

func _ready():
	Global.state_add.connect(add_state)
	Global.state_remove.connect(remove_state)

# Добавление нового состояния
func add_state(state_type: int) -> void:
	# Используем значение по умолчанию если не указано
	var duration = durations[state_type]
	
	# Получаем текстуру
	var texture: Texture2D = state_textures[state_type]
	
	# Создаем информацию о состоянии
	var state_info = StateInfo.new(state_type, duration, texture)
	
	# Подключаем сигнал окончания времени
	state_info.timer.timeout.connect(_on_state_timeout.bind(state_info))
	
	# Добавляем узлы в сцену
	add_child(state_info.sprite)
	add_child(state_info.timer)
	
	# Добавляем в массив активных состояний
	active_states.append(state_info)
	
	# Запускаем таймер
	state_info.timer.start()
	
	# Обновляем позиции всех состояний
	_update_states_positions()
	
	# Эмитируем сигнал
	#Global.state_add.emit(state_type)

# Обработчик окончания времени состояния
func _on_state_timeout(state_info: StateInfo) -> void:
	remove_state(state_info)

# Удаление состояния
func remove_state(state_info: StateInfo) -> void:
	var index = active_states.find(state_info)
	if index == -1:
		return
	
	var state_type = state_info.state_type
	
	# Удаляем узлы из сцены
	if state_info.sprite and state_info.sprite.is_inside_tree():
		state_info.sprite.queue_free()
	if state_info.timer and state_info.timer.is_inside_tree():
		state_info.timer.queue_free()
	
	# Удаляем из массива
	active_states.remove_at(index)
	
	# Обновляем позиции всех состояний
	_update_states_positions()
	
	# Эмитируем сигнал
	Global.state_remove.emit(state_type)

# Обновление позиций всех состояний
func _update_states_positions() -> void:
	for i in range(active_states.size()):
		var state_info = active_states[i]
		var position = _calculate_state_position(i)
		state_info.sprite.position = position

# Вычисление позиции состояния по индексу
func _calculate_state_position(index: int) -> Vector2:
	# Вычисляем позицию в сетке
	var row = index / MAX_STATES_PER_ROW
	var col = index % MAX_STATES_PER_ROW
	
	# Так как состояния добавляются слева направо, но отображаются справа налево
	# инвертируем колонку
	#col = MAX_STATES_PER_ROW - 1 - col
	
	# Вычисляем координаты
	var x = get_viewport().get_visible_rect().size.x - (col + 1) * (STATE_SIZE.x + HORIZONTAL_SPACING)
	var y = row * (STATE_SIZE.y + VERTICAL_SPACING)
	
	return Vector2(x, y)

# Получение количества строк
func _get_rows_count() -> int:
	if active_states.size() == 0:
		return 0
	return (active_states.size() - 1) / MAX_STATES_PER_ROW + 1

# Установка текстуры для состояния
func set_state_texture(state_type: int, texture: Texture2D) -> void:
	if state_type >= state_textures.size():
		# Расширяем массив если нужно
		while state_textures.size() <= state_type:
			state_textures.append(null)
	
	state_textures[state_type] = texture
	
	# Обновляем текстуры для активных состояний этого типа
	for state_info in active_states:
		if state_info.state_type == state_type:
			state_info.sprite.texture = texture

# Установка времени действия для состояния
#func set_state_duration(state_type: int, duration: float) -> void:
	#if state_type < default_durations.size():
		#default_durations[state_type] = duration
	#else:
		## Расширяем массив если нужно
		#while default_durations.size() <= state_type:
			#default_durations.append(3.0)
		#default_durations[state_type] = duration

# Получение информации о состоянии
func get_active_states_count() -> int:
	return active_states.size()

func get_state_info(index: int) -> Dictionary:
	if index < 0 or index >= active_states.size():
		return {}
	
	var state_info = active_states[index]
	return {
		"type": state_info.state_type,
		"duration": state_info.duration,
		"time_left": state_info.timer.time_left,
		"sprite": state_info.sprite
	}

# Очистка всех состояний
func clear_all_states() -> void:
	for state_info in active_states.duplicate():
		remove_state(state_info)
