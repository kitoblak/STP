# Inventory.gd
extends Control

@onready var cell_container = $CellContainer
@onready var UI = get_parent()

var cell_size = 64  # Size of each cell in pixels
var grid_cols = 4   # Number of columns in the grid
var grid_rows = 4   # Number of rows in the grid

func _ready():
	Global.InventoryToggle.connect(toggle_inventory)
	
	hide_inventory()
	
	position.x = get_viewport().get_visible_rect().size.x / 2
	position.y = get_viewport().get_visible_rect().size.y / 2
	
	scale.x *= UI.ZOOM * 3
	scale.y *= UI.ZOOM * 3

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
	
	# Create cells if they don't exist yet
	if cell_container.get_child_count() == 0:
		create_cells()

func hide_inventory():
	hide()

func create_cells():
	for row in range(grid_rows):
		for col in range(grid_cols):
			var cell = preload("res://scene/Cell/cell.tscn").instantiate()
			cell.position = Vector2(col * cell_size, row * cell_size)
			cell.size = Vector2(cell_size * UI.ZOOM, cell_size * UI.ZOOM)
			cell_container.add_child(cell)
