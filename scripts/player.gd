extends CharacterBody2D


const SPEED = 300.0
const JUMP_FORCE = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direcao_atual = 'r'
var direcao_atualizada = false
var life = 100

# interfasse gráfica
var life_bar_value : ProgressBar
var dano_sofrido = false
var direcao_dano : int = 0

func _ready():
	# pegando referência dos itens
	life_bar_value = get_node("/root/World-01/GUI_itens/life/ProgressBar_life")
	
	set_raposinha_parada(1)
	$andando_4.play()
	$parada_4.play()

func sofreu_dano(dano:int, direction:int):
	life -= dano
	life_bar_value.value = life
	dano_sofrido = true
	direcao_dano = direction
	if life == 0:
		queue_free()
		print("voce perdeu")
	
func set_raposinha_andando(direction:int):
	$parada_4.visible = false
	$andando_4.visible = true
	if direction >= 1 and $andando_4.scale.x > 0:
		$andando_4.scale.x *= -1 # girar personagem
		direcao_atual = 'r'
		direcao_atualizada = false
	elif direction <= 0 and $andando_4.scale.x < 0:
		$andando_4.scale.x *= -1 # girar personagem
		direcao_atual = 'l'
		direcao_atualizada = false
		
func set_raposinha_parada(direction:int):
	$parada_4.visible = true
	$andando_4.visible = false
	
	if not direcao_atualizada and direcao_atual == 'r': # direita
		if $parada_4.scale.x > 0:
			$parada_4.scale.x *= -1 # girar personagem
		direcao_atualizada = true
		
	elif not direcao_atualizada and direcao_atual == 'l': # esquerda
		if $parada_4.scale.x < 0:
			$parada_4.scale.x *= -1 # girar personagem
		direcao_atualizada = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE

	# __Movimentação personagem
	var direction = 0
	
	if not dano_sofrido:
		direction = Input.get_axis("ui_left", "ui_right")
		velocity.x = direction * SPEED
		
		if direction != 0:
			set_raposinha_andando(direction) # animação sprite
		else:
			set_raposinha_parada(direction)
	
	elif dano_sofrido:
		if $parada_4.visible == true: # raposinha parada
			if direcao_atual == 'r' and direcao_dano > 0:
				velocity.x = 5 * SPEED
			elif direcao_atual == 'r' and direcao_dano < 0:
				velocity.x = -5 * SPEED
			elif direcao_atual == 'l' and direcao_dano > 0:
				velocity.x = 5 * SPEED
			elif direcao_atual == 'l' and direcao_dano < 0:
				velocity.x = -5 * SPEED
		else: # andando
			if direcao_atual == 'r' and direcao_dano > 0:
				velocity.x = -5 * SPEED
			elif direcao_atual == 'r' and direcao_dano < 0:
				velocity.x = -5 * SPEED
			elif direcao_atual == 'l' and direcao_dano > 0:
				velocity.x = 5 * SPEED
			elif direcao_atual == 'l' and direcao_dano < 0:
				velocity.x = 5 * SPEED
		
		dano_sofrido = false
	
	'''else: # parece que está inutilizavel
		# parada
		velocity.x = move_toward(velocity.x, 0, SPEED)'''

	move_and_slide()
