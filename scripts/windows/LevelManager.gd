extends Node2D

var coins_collected = 0

func add_coins(amount):
	coins_collected += amount
	$UI/CoinLabel.text = str(coins_collected)

func update_fuel_UI(value):
	$UI/ProgressBar.value = value
	if value < 40:
		$UI/Alarm.visible = true
		$UI/Alarm/AlarmPlayer.play("Alarm")
	if value > 40:
		$UI/Alarm.visible = false

func update_distance_UI(value):
	$UI/Distance.text = str(abs(value))
