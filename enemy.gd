extends CharacterBody2D

@export var speed = 150
@export var jump_impulse = -400
@export var gravity = 900
@export var health = 3

var is_dead = false
var direction = 1  # 1 = right, -1 = left

func _ready() -> void:
	$AnimatedSprite2D.play("Idle")

func _physics_process(delta: float) -> void:
	if is_dead:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("Death")
		return
		
		_ai_move(delta)
		move_and_slide()
		_update_animation()

func _ai_move(delta: float):
	# Move enemy
	velocity.x = speed * direction
	
	#tarkista törmäys seinään
	var collision = move_and_collide(Vector2(velocity.x * delta, 0))
	if collision:
		direction *= -1 # käännä suunta
		velocity.x = speed * direction

func _update_animation():
	if is_dead:
		$AnimatedSprite2D.play("Death")
		return
		
	if $AnimatedSprite2D.is_playing() and $AnimatedSprite2D.animation == "Damage":
		return
		
	if velocity.y < 0:
		$AnimatedSprite2D.play("Jump")
	elif velocity.y > 0:
		$AnimatedSprite2D.play("Fall")
	elif velocity.x != 0:
		$AnimatedSprite2D.play("Walk")
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.play("Idle")
		


func take_damage(amount: int = 1):
	if is_dead:
		return
		health -= amount
		$AnimatedSprite2D.play("Damage")
		if health <= 0:
			is_dead = true
			$AnimatedSprite2D.play("Death")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$AnimatedSprite2D.play("Attack")
		print("Enemy hits player")
