extends Area2D

signal hit

export var speed: int = 400

var target: Vector2 = Vector2()

onready var screenSize: Vector2 = get_viewport_rect().size
onready var sprite := $AnimatedSprite
onready var collider := $CollisionShape2D

func _ready() -> void:
	var _err = self.connect("body_entered", self, "OnPlayerBodyEntered")
	hide()

func Start(pos: Vector2) -> void:
	position = pos
	target = pos
	show()
	collider.disabled = false

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		target = event.position

func _process(delta: float) -> void:
	var velocity: Vector2 = Vector2()
	
	if position.distance_to(target) > 10:
		velocity = target - position
	
#	if Input.is_action_pressed("ui_right"):
#		velocity.x += 1
#	if Input.is_action_pressed("ui_left"):
#		velocity.x -= 1
#	if Input.is_action_pressed("ui_down"):
#		velocity.y += 1
#	if Input.is_action_pressed("ui_up"):
#		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		sprite.play()
	else:
		sprite.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screenSize.x)
	position.y = clamp(position.y, 0, screenSize.y)
	
	if velocity.x != 0:
		sprite.animation = "walk"
		sprite.flip_v = false
		sprite.flip_h = velocity.x < 0
	elif velocity.y !=0:
		sprite.animation = "up"
		sprite.flip_v = velocity.y > 0

func OnPlayerBodyEntered(_body: Node) -> void:
	hide()
	emit_signal("hit")
	collider.set_deferred("disabled", true)
