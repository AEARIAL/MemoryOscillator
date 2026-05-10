extends Node2D

# インスペクターから生成したいコインのシーンを選択可能にする
@export var coin_scene: PackedScene = preload("res://scenes/stageobj/Coin.tscn")

@export_group("Spawn Settings")
# 一度に生成するコインの個数（難易度調整などに利用）
@export var spawn_count: int = 10

# 子ノードのReferenceRect（生成範囲のガイド）を準備完了時に取得
@onready var spawn_area: ReferenceRect = $SpawnArea

func _ready() -> void:
	# シーン開始時に即座に一括生成メソッドを呼び出す
	spawn_all_coins()

## 指定された範囲内にコインをまとめて配置する関数
func spawn_all_coins() -> void:
	# コインのシーンが設定されていない場合はエラーを防ぐために中断
	if not coin_scene:
		push_warning("CoinSpawner: coin_sceneが未設定です。")
		return

	# ReferenceRectからエディタで設定したサイズ(Size)と位置を取得
	var area_rect = spawn_area.get_rect()

	# 指定された個数分だけループして生成処理を行う
	for i in range(spawn_count):
		# 範囲内（0〜Size）のどこかにランダムな座標（ローカル）を決定
		var random_pos = Vector2(
			randf_range(0, area_rect.size.x),
			randf_range(0, area_rect.size.y)
		)
		
		# ReferenceRectのグローバル位置にランダム座標を足して、世界基準の座標にする
		var global_spawn_pos = spawn_area.global_position + random_pos
		
		# コインシーンのインスタンス（実体）を作成
		var coin = coin_scene.instantiate()
		
		# 【重要】準備中エラーを防ぐため、現在のシーンへ「後で」追加するよう予約
		get_tree().current_scene.add_child.call_deferred(coin)
		
		# 生成したコインの場所を計算したグローバル座標にセット
		coin.global_position = global_spawn_pos
		
		# デバッグ用にどの座標に生成されたかログを表示（確認後消してOK）
		print("Coin ", i, " spawned at: ", global_spawn_pos)
