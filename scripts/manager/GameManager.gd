extends Node

# --- シグナル定義 ---
# スコアが更新されたときにUIなどへ通知するためのシグナル
signal score_changed(new_score: int)
# プレイヤーの死亡やタイムアップなど、ゲームオーバー時に通知するシグナル
signal game_over

# --- 変数定義 ---
# 現在のステージに存在するコインの総数
var total_coins_in_stage: int = 0
# 現在のステージでプレイヤーが拾ったコインの数
var collected_coins_in_stage: int = 0

# プレイヤーの総スコア。値が書き換わると自動的に set(value) が実行される
var score: int = 0 :
	set(value):
		score = value
		# スコアが更新されるたびにシグナルを送信し、UI側が検知できるようにする
		score_changed.emit(score)

# --- スコア・進行管理ロジック ---

## スコアを加算し、クリア判定を行う関数
func add_score(amount: int) -> void:
	# スコアを加算（セッターが走り、シグナルが飛ぶ）
	score += amount
	
	# コンソールに現在のスコアを表示（デバッグ用）
	print("Current Score: ", score)
	
	# ステージ内での収集数をカウントアップ
	collected_coins_in_stage += 1
	
	# 収集した数がステージ内の総数に達した（または超えた）場合、次のステージへ
	if collected_coins_in_stage >= total_coins_in_stage:
		go_to_next_stage()

## ゲームの状態を初期化し、現在のステージをやり直す関数
func reset_game() -> void:
	score = 0
	# 現在実行中のシーン（ステージ）を最初から読み直す
	get_tree().reload_current_scene()

## ステージ開始時、スポナー等から「配置されたコインの数」を登録する関数
func register_total_coins(amount: int):
	# ステージ全体の枚数を設定
	total_coins_in_stage = amount
	# 収集状況をリセット
	collected_coins_in_stage = 0
	# デバッグ用：クリア条件を表示
	print("Total coins registered: ", amount)

## ステージクリア時の処理を行う関数
func go_to_next_stage():
	print("Stage Clear!")
	# TODO: 次のステージへの遷移処理を記述する
	# 例: get_tree().change_scene_to_file("res://scenes/stage/Stage02.tscn")
