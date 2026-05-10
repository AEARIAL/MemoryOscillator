extends Area2D

@export var score_value: int = 10 

func _ready() -> void:
	# 衝突イベントを接続
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# 衝突した相手の名前を確認（デバッグ用）
	print("Hit: ", body.name)

	# 相手が Player という名前だった場合
	if body.name == "Player":
		# GameManagerが存在するかチェックしてから加算
		if GameManager:
			GameManager.add_score(score_value)
		
		# コインを消去
		queue_free()
