extends Node

# Local Handlers
onready var ScreenHandler = get_node("ScreenHandler")

# current game data
var game_state

func _ready():
	randomize()
	# when the game starts from scratch, ask the game state handler for the most recent save
	# if there is no recent save, initialize with galaxy defaults and pick first race
	game_state = GameStateHandler.get_most_current_game_state()
	
	ScreenHandler.connect_signals()
	EventHandler.anchor_object = get_node("EventAnchor")
	TurnHandler.connect("turn_finished", ScreenHandler, "_update_turn")
	ScreenHandler.title_screen()
	#save_game_state()
	set_process(true)
	set_process_input(true)
	pass
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		ScreenHandler.return_screen()
	# DEBUG keys
	if event.type == InputEvent.KEY and event.scancode == KEY_E:
		pass

func _process(delta):
	pass