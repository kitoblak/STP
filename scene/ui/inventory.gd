# Inventory.gd
extends Control

@onready var cell_container = $CellContainer
@onready var UI = get_parent()

var cell_size = 100  # Size of each cell in pixels
var grid_cols = 4   # Number of columns in the grid
var grid_rows = 4   # Number of rows in the grid

var CellsPositions: Array[Vector2] = [\
	Vector2(100, 100), \
	Vector2(100, 200), \
	Vector2(100, 300), \
	
	Vector2(250, 100), \
	
	Vector2(400, 100), \
	Vector2(500, 100), \
	Vector2(600, 100), \
	Vector2(700, 100), \
	
	Vector2(250, 300), \
	Vector2(350, 300), \
	
	Vector2(500, 300), \
	Vector2(600, 300), \
	Vector2(700, 300), \
]



func _ready():
	Global.InventoryToggle.connect(toggle_inventory)
	
	hide_inventory()
	
	position.x = get_viewport().get_visible_rect().size.x / 2
	position.y = get_viewport().get_visible_rect().size.y / 2
	
	scale.x *= UI.ZOOM * 3
	scale.y *= UI.ZOOM * 3
	
	size.x = 800
	size.y = 850
#func _input(event):
	#if event.is_action_pressed("Inventory"):
		#toggle_inventory()

func toggle_inventory():
	if visible:
		hide_inventory()
	else:
		show_inventory()

func show_inventory():
	show()
	grab_focus()
	
	# Create cells if they don't exist yet
	if cell_container.get_child_count() == 0:
		create_cells()

func hide_inventory():
	hide()

func create_cells():
	for pos in CellsPositions:
		var cell = preload("res://scene/Cell/cell.tscn").instantiate()
		cell.position = pos - Vector2(size.x / 2, size.y / 2)
		cell.size = Vector2(cell_size * UI.ZOOM, cell_size * UI.ZOOM)
		cell_container.add_child(cell)
