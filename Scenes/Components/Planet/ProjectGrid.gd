extends Position2D

var ProjectGridButton = preload("res://Scenes/Components/Planet/ProjectGridButton.gd")
var BuildingRules = preload("res://Scripts/BuildingRules.gd")
onready var container = get_node("GridContainer")

func _ready():
	pass

# TODO: this belongs into more detached game rules and planet management classes because the AI doesn't see screens
func get_projects_for_surface(planet, cell, building_tile):
	var br = BuildingRules.new()
	return br.get_projects_for_surface(planet, cell, building_tile)

func get_sprites_for_projects(projects, tile, type = "Surface"):
	var texturebuttons = []
	if not type in ["Surface", "Orbital", "Tech"]:
		print("Unknown tile type %s" % type)
		return null
	for p in range(projects.size()):
		var project = projects[p]
		texturebuttons.append(ProjectGridButton.new(project, tile, type))
	return texturebuttons
	pass

func clear_buttons():
	var current_buttons = container.get_children()
	for b in current_buttons:
		b.hide()
		b.queue_free()
		container.remove_child(b)

func set_buttons_on_container(buttons):
	clear_buttons()
	for b in buttons:
		container.add_child(b)
	
# TODO: when you click on the projects button, you get to pick a project first, THEN a tile