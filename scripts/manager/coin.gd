extends Area2D

# コインが取得されたことを外部（GameManagerなど）に伝えるためのシグナル
signal collected

func _ready() -> void:
	# 自身の body_entered シグナルをこのスクリプトの関数に接続
	# プレイヤー（CharacterBody2D）が接触した時に発火します
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# 接触した対象が "Player" という名前、もしくは Player クラスであるか確認
	# (より厳密には body is CharacterBody2D などのチェックが望ましい)
	if body.name == "Player":
		# シグナルを発火
		collected.emit()
		
		# ログ出力（デバッグ用）
		print("コインをゲットしました！")
		
		# コインをシーンから削除
		queue_free()
