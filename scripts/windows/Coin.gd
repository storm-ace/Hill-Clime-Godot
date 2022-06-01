tool
extends Area2D

export(int, 0, 3) var coinIndex = 0 setget loadSprite

var coins = [5, 10, 25, 50]
var coinPath = "res://Images/Pickups/Coin" + str(coins[coinIndex]) + ".png"
var coinImg = load(coinPath)

func loadSprite(data):
	coinPath = "res://Images/Pickups/Coin" + str(coins[data]) + ".png"
	coinImg = load(coinPath)
	$Sprite.texture = coinImg
	coinIndex = data

func _on_Coin_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().get_current_scene().add_coins(coins[coinIndex])
		$AnimationPlayer.play("Pickup")
		$CollisionShape2D.set_deferred("disabled", true)


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
