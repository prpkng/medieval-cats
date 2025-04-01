class_name EnemyUnit extends Unit
## A common class describing an enemy, defines some stuff like death handling


func _on_death():
	queue_free()