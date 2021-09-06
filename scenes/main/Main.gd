extends Node

export var MobGO: PackedScene

var score: int = 0

onready var scoreTimer := $ScoreTimer
onready var startTimer := $StartTimer
onready var mobTimer := $MobTimer
onready var player := $Player
onready var mobSpawnLoc := $MobPath/MobSpawnLocation
onready var startPos := $StartPosition
onready var hud := $HUD
onready var music := $Music
onready var deathSound := $DeathSound

func _ready() -> void:
	randomize()
	var _err = player.connect("hit", self, "GameOver")
	_err = scoreTimer.connect("timeout", self, "ScoreTimeout")
	_err = startTimer.connect("timeout", self, "StartTimeout")
	_err = mobTimer.connect("timeout", self, "MobTimeout")
	_err = hud.connect("start_game", self, "NewGame")
	
func GameOver() -> void:
	scoreTimer.stop()
	mobTimer.stop()
	hud.ShowGameOver()
	get_tree().call_group("mobs", "queue_free")
	music.stop()
	deathSound.play()

func NewGame() -> void:
	score = 0
	player.Start(startPos.position)
	startTimer.start()
	hud.UpdateScore(score)
	hud.ShowMessage("Get Ready")
	music.play()

func ScoreTimeout() -> void:
	score += 1
	hud.UpdateScore(score)

func StartTimeout() -> void:
	mobTimer.start()
	scoreTimer.start()

func MobTimeout() -> void:
	mobSpawnLoc.offset = randi()
	var mob := MobGO.instance()
	# print(mob.get_class())
	add_child(mob)
	var direction: float = mobSpawnLoc.rotation + PI / 2
	mob.position = mobSpawnLoc.position
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	mob.linear_velocity = Vector2(rand_range(mob.minSpeed, mob.maxSpeed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
