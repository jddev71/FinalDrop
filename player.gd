extends CharacterBody3D

@export var speed := 6.0
@export var jump_force := 4.5
@export var mouse_sensitivity := 0.002
@export var gravity := 9.8

var rotation_x := 0.0

@onready var camera = $Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		# Rotación horizontal (player)
		rotate_y(-event.relative.x * mouse_sensitivity)
		
		# Rotación vertical (cámara)
		rotation_x -= event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, deg_to_rad(-90), deg_to_rad(90))
		camera.rotation.x = rotation_x

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	var forward = -transform.basis.z
	var right = transform.basis.x
	
	if Input.is_action_pressed("move_forward"):
		direction += forward
	if Input.is_action_pressed("move_backward"):
		direction -= forward
	if Input.is_action_pressed("move_left"):
		direction -= right
	if Input.is_action_pressed("move_right"):
		direction += right
	
	direction = direction.normalized()
	
	# Movimiento horizontal
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	# Gravedad y salto
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_force
		else:
			velocity.y = 0
	
	move_and_slide()
