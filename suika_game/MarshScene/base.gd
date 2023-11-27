#Rigidbody2Dで物理エンジンを作る
#Sprite2Dで画像を表示
#CollisionShape2Dで当たり判定 
extends RigidBody2D
#変数作成(インスペクターで変更可能)
@export var NextMash: PackedScene
@export var GroupName = "Mash0s"
@export var score = 0
var is_checked = false#オブジェクトが合体したときの処理用(判定中ならTrue)
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(GroupName)

func _process(delta):
	pass

func isChecked():#パラメータを教える関数、他のオブジェクトかチェックできる
	return is_checked
func setChecked():#他のオブジェクトから値をセット
	is_checked = true

func _on_body_entered(body):#Rigidbody2Dで触れたことを知る、あたったものが引数bodyに入る
	if NextMash:#最大のオブジェクトは無視する
		if body.is_in_group(GroupName):#同じグループか確認(同じグループなら次のオブジェクトを作成)
			
			if body.position >= position:#二つのオブジェクトの合成時、上のほうを判定基準に
				if !body.isChecked():
					is_checked = true
					body.setChecked()
					
					#新しいオブジェクトの位置を決める
					var pop_mash = NextMash.instantiate()
					var pop_pos = (body.position + position)/2
					pop_mash.position = pop_pos
					
					#新しいオブジェクトをmainシーンの子に設定
					get_parent().call_deferred("add_child",pop_mash)#関数呼び出し
					get_parent().call_deferred("add_score",score)#mainのスコア関数呼び出し
					get_parent().call_deferred("pop_particle",pop_pos)#mainのパーティクル関数を呼び出し
					#自分と相手を削除
					body.queue_free()
					queue_free()
	if body.name == "Limit":
		get_parent().call_deferred("game_over")

func jump_out():
	#var bottleCenter = Vector2(360,640)
	#var forceDirection = (position - bottleCenter).normalized()
	PhysicsServer2D.set_active(false)
	#var shootSpeed = 500.0
	#var shootForce = forceDirection * shootSpeed
	#set_gravity_scale(0.0)
	#apply_central_impulse(shootForce)
	#$CollisionShape2D.set_deferred("disabled",true)
