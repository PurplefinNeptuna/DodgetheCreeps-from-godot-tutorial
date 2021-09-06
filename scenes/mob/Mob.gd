extends RigidBody2D

export var minSpeed: int = 150
export var maxSpeed: int = 250

onready var sprite := $AnimatedSprite
onready var visNotif := $VisibilityNotifier2D
onready var mobTypes: PoolStringArray = sprite.frames.get_animation_names()

func _ready() -> void:
	sprite.animation = mobTypes[randi() % mobTypes.size()]
	var _err = visNotif.connect("screen_exited", self, "OnExitScreen")

func OnExitScreen() -> void:
	queue_free()
