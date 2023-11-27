extends Sprite2D

var speed = 5#移動スピード

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input := Vector2.ZERO#インプット変数を初期化
	#input.x += 1
	input.x = Input.get_axis("move_left","move_right")#キー入力を取得
	if Input.is_action_pressed("move_right"):
		print("右")
		flip_h = true
	elif Input.is_action_pressed("move_left"):
		print("左")
		flip_h = false
	position.x += input.x * speed
	if position.x > 600:
		position.x = 120
	if position.x < 120:
		position.x = 600
