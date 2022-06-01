extends Area2D

func _on_Coin_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().get_current_scene().get_node("Player").refuel()
		$AnimationPlayer.play("Pickup")
		$CollisionShape2D.set_deferred("disabled", true)

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
