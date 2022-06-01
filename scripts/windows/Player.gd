extends RigidBody2D

var wheels = []
export var speed = 1200
export var frictionValue = .3
export var max_speed = 50
export var fuel = 100
var dead = false

var startPosition = 0
var endPosition = 0

func _ready():
	wheels = get_tree().get_nodes_in_group("Wheel")
	
	#Setup friction
	for wheel in wheels:
		wheel.friction = frictionValue
		
	get_parent().update_fuel_UI(fuel)
	startPosition = position.x
func _physics_process(delta):
	use_fuel(2, delta)
	
	var distance = (startPosition - position.x) / 100
	get_parent().update_distance_UI(int(distance))
	
	if fuel > 0 && !dead:
		if Input.is_action_pressed("ui_right"):
			movement(true, delta)
		if Input.is_action_pressed("ui_left"):
			movement(false, delta)
		if !Input.is_action_pressed("ui_right") && !Input.is_action_pressed("ui_left"):
			$EngineSound.pitch_scale = 0.3
	else:
		if $GameOverTimer.is_stopped():
			$GameOverTimer.start()
			$EngineSound.pitch_scale = .1
			endPosition = position.x
	
	if $Head.rotation_degrees > 90 || $Head.rotation_degrees < -90 && !dead:
		dead = true
		$Head/HeadSprint.node_b = ""	
	
	#If the car goes backwards the timer will start
	if endPosition != 0 && (position.x - endPosition) / 100 < 0 && fuel <= 0:
			get_tree().reload_current_scene()
	elif abs($WheelHolder/Wheel.angular_velocity) > 3 && !dead && fuel <= 0:
			$GameOverTimer.stop()
func movement(forward, delta):
	use_fuel(10, delta)
	handleEngineSound(delta)
	if forward:
		apply_torque_impulse(2000 * delta * 60)
		for wheel in wheels:
			if wheel.angular_velocity < max_speed:
				wheel.apply_torque_impulse(speed * delta * 60)
	else:
		apply_torque_impulse(-2000 * delta * 60)
		for wheel in wheels:
			if wheel.angular_velocity < max_speed:
				wheel.apply_torque_impulse(-speed / 2 * delta * 60)
func refuel():
	fuel = 100
	get_parent().update_fuel_UI(fuel)
	#Prevents the game from stopping if we reach a refuel
	$GameOverTimer.stop()
func use_fuel(amount, delta):
	fuel -= amount * delta
	fuel = clamp(fuel, 0, 100)
	get_parent().update_fuel_UI(fuel)
func _on_GameOverTimer_timeout():
	get_tree().reload_current_scene()
func handleEngineSound(delta):
	if fuel <= 0:
		$EngineSound.stream_paused = true 
		return;
	else:
		$EngineSound.stream_paused = false
	
	if abs($WheelHolder/Wheel.angular_velocity) > 5:
		$EngineSound.pitch_scale = lerp($EngineSound.pitch_scale, .5, delta * 1)
	if abs($WheelHolder/Wheel.angular_velocity) > 10:
		$EngineSound.pitch_scale = lerp($EngineSound.pitch_scale, .8, delta * 1)
	if abs($WheelHolder/Wheel.angular_velocity) > 20:
		$EngineSound.pitch_scale = lerp($EngineSound.pitch_scale, 1, delta * 1)
	if abs($WheelHolder/Wheel.angular_velocity) > 30:
		$EngineSound.pitch_scale = lerp($EngineSound.pitch_scale, 1.5, delta * 1)
	if abs($WheelHolder/Wheel.angular_velocity) > 40:
		$EngineSound.pitch_scale = lerp($EngineSound.pitch_scale, 1.8, delta * 1)
	if abs($WheelHolder/Wheel.angular_velocity) >= 50:
		$EngineSound.pitch_scale = lerp($EngineSound.pitch_scale, 2, delta * 1)
