extends CanvasLayer

signal start_game

onready var message := $Message
onready var messageTimer := $MessageTimer
onready var startButton := $StartButton
onready var scoreLabel := $ScoreLabel

func _ready() -> void:
	var _err = messageTimer.connect("timeout", self, "OnMessageTimerTimeout")
	_err = startButton.connect("pressed", self, "OnStartButtonPressed")

func ShowMessage(text: String) -> void:
	message.text = text
	message.show()
	messageTimer.start()

func ShowGameOver() -> void:
	ShowMessage("Game Over")
	yield(messageTimer, "timeout")
	
	message.text = "Dodge the\nCreeps!"
	message.show()
	
	yield(get_tree().create_timer(1), "timeout")
	startButton.show()
	
func UpdateScore(score: int) -> void:
	scoreLabel.text = str(score)

func OnStartButtonPressed() -> void:
	startButton.hide()
	emit_signal("start_game")

func OnMessageTimerTimeout() -> void:
	message.hide()
