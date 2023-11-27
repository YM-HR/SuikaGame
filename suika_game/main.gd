extends Node
@export var mash_score:Array[PackedScene]#マシュマロのシーンの配列を登録
var nowIndex#現在のオブジェクト用変数
var nextIndex = randi_range(0,3)#次のマシュマロ用変数
var totalScore = 0#スコア初期値
var hi_score = ReTry.hiscore
@onready var main_bgm = $MainBgm
@onready var over_bgm = $GameOverBgm
@onready var effect1_bgm = $SoundEffect1
@onready var effect2_bgm = $SoundEffect2
# Called when the node enters the scene tree for the first time.
func _ready():#シーンに入って一度だけ行う処理
	# BGM再生.
	over_bgm.stop()
	main_bgm.play()
	change_image()#関数呼び出し
	$Score.text = str(totalScore)
	#print(typeof(hi_score))#0->null,2->int
	if typeof(hi_score)==0:hi_score = 0
	$VestScore.text =  "ハイスコア: %d"%(hi_score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):#ずっと行う処理
	$SelectMash.position = $Player.position#オブジェクトをPlayerの位置に固定
	# デバッグの更新.
	_update_debug()
	if Input.is_action_just_pressed("drop",true):#スペースキーが押されたとき
		if $SelectMash.visible:#SelectMashが表示されてて
			if !$GameOver.visible:#GameOverが非表示ならオブジェクトを落とす
				effect1_bgm.play()
				drop()
				await get_tree().create_timer(0.8).timeout
				change_image()
				

func drop():
	var dropmash = mash_score[nowIndex].instantiate()
	add_child(dropmash)
	dropmash.position = $SelectMash.position
	$SelectMash.hide()

func change_image():#絵を変更する関数
	nowIndex = nextIndex
	nextIndex = randi_range(0,3)
	
	var texture = load("res://art/mash" + str(nowIndex) + ".png")#テクスチャを呼び出す
	$SelectMash.set_texture(texture)#上のテクスチャをSelectMashに入れる
	$SelectMash.show()#表示

	texture = load("res://art/mash" + str(nextIndex) + ".png")#テクスチャを呼び出す
	$NextMash.set_texture(texture)#上のテクスチャをNextMashに入れる

func add_score(score):
	totalScore += score
	if hi_score < totalScore:
			hi_score = totalScore
	$Score.text =  str(totalScore)
	$VestScore.text =  "ハイスコア: %d"%(hi_score)
	
func  pop_particle(pos):#パーティクル用関数
	effect2_bgm.play()
	$Particles_star.position = pos#座標を代入
	$Particles_star.set_deferred("emitting",true)#emittingのパラメータをtrueに
	#$VestScore.text = str(totalScore)
func game_over():
	main_bgm.stop()
	over_bgm.play()
	$SelectMash.hide()
	$GameOver.show()
	$ReTry.show()
	#$Limit.get_node("CollisionShape2D").set_deferred("disabled",true)
	get_tree().call_group("Mashs","jump_out")
	
## 更新 > デバッグ.
func _update_debug() -> void:
	if Input.is_action_pressed("reset"):
		# リセット.
		# 物理を有効に戻す.
		PhysicsServer2D.set_active(true)
		ReTry.hiscore = hi_score
		get_tree().change_scene_to_file("res://Main.tscn")
	
