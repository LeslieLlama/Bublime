extends CanvasLayer

@export var tutorialScreens = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	tutorialScreens = [$TutorialScreen1]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _enable_tutorial_screen(screen : int, is_show):
	if is_show == true:
		tutorialScreens[screen].show()
	else:
		tutorialScreens[screen].hide()
