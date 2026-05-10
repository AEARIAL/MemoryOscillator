extends CharacterBody2D

# ---------------------------------------------------------
# 主要変数 (Properties)
# @export をつけることで、インスペクターから直接数値を調整できるようになります
# ---------------------------------------------------------
@export var speed: float = 300.0
@export var jump_velocity: float = -400.0
@export var gravity: float = 980.0 

# ---------------------------------------------------------
# 主要関数 (Methods)
# ---------------------------------------------------------
func _physics_process(delta: float) -> void:
	# 1. 重力計算 (空中にいる場合のみ下方向へ加速)
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. ジャンプ処理 (床にいて、ui_accept(Space/Enterキー等)が押された時)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# 3. 移動計算 (ui_left / ui_right などの入力方向を取得)
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		# 入力がない場合は減速して止まる
		velocity.x = move_toward(velocity.x, 0, speed)

	# 実際に移動と壁・床との衝突判定を行う組み込み関数
	move_and_slide()
	
	# 4. 落下判定のチェック
	check_fall_zone()

# ---------------------------------------------------------
# 落下判定 (Y > 1000)
# ---------------------------------------------------------
func check_fall_zone() -> void:
	if global_position.y > 1000:
		# TODO: v-0.4.0でGameManagerが完成したら、ミス処理やリスタート処理に置き換えます
		print("落下ミス！ Y座標が1000を超えました。")
		
		# 開発用の仮処理：初期位置(0, 0)に戻す
		global_position = Vector2.ZERO
		velocity = Vector2.ZERO
