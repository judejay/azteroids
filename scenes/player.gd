extends RigidBody2D

signal lives_changed
signal shield_changed
signal dead
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var muzzle_: Marker2D = $"Muzzle"
@export var engine_power = 500
@export var spin_power = 8000

@export var bullet_scene : PackedScene
@export var fire_rate = 0.25
@export var max_shield = 100.0

var can_shoot = true
enum {INIT, ALIVE, DEAD, INVULNERABLE}
var state = INIT
var reset_pos = false
var lives = 0: set = set_lives
var thrust = Vector2.ZERO
var rotation_dir = 0
var screensize = Vector2.ZERO
var shield = 0: set = set_shield



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    change_state(ALIVE)
    screensize = get_viewport_rect().size
    $GunCooldown.wait_time = fire_rate


func _integrate_forces(physics_state):
    var xform = physics_state.transform
    xform.origin.x = wrapf(xform.origin.x, 0, screensize.x)
    xform.origin.y = wrapf(xform.origin.y, 0, screensize.y)
    physics_state.transform = xform
    if reset_pos:
      physics_state.transform.origin = screensize / 2
      reset_pos = false
    
func set_shield(value):
    value = min(value, max_shield)
    shield = value 
    shield_changed.emit(shield / max_shield)
    if shield <= 0:
        lives -= 1
        explode()
            
func set_lives(value):
    lives = value
    shield = max_shield
    lives_changed.emit(lives)
    if lives <= 0:
        change_state(DEAD)
    else:
        change_state(INVULNERABLE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    get_input()


func change_state(new_state):
    match new_state:
        INIT:
            $CollisionShape2D.set_deferred("disabled", true)
        ALIVE:
            $CollisionShape2D.set_deferred("disabled", false)
        INVULNERABLE:
            $CollisionShape2D.set_deferred("disabled", true)
        DEAD:
            $CollisionShape2D.set_deferred("disabled", true)
    state = new_state
    
func get_input():
    thrust = Vector2.ZERO
    #$Exhaust.emitting = false
    if state in [DEAD, INIT]:
        return
    if Input.is_action_pressed("thrust"):
        thrust = transform.x * engine_power
        #$Exhaust.emitting = true
        #if not $EngineSound.playing:
            #$EngineSound.play()
    else:
        #$EngineSound.stop()
        pass
    rotation_dir = Input.get_axis("rotate_left", "rotate_right")
    if Input.is_action_pressed("shoot") and can_shoot:
        shoot()
        
func explode():
   pass
        
func _physics_process(delta):
    constant_force = thrust
    constant_torque = rotation_dir * spin_power
    
func shoot():
 if state == INVULNERABLE:
  return
 can_shoot = false
 $GunCooldown.start()
 var b = bullet_scene.instantiate()
 get_tree().root.add_child(b)
 b.start(muzzle_.global_transform)


func _on_gun_cooldown_timeout():
 can_shoot = true


func reset():
    reset_pos = true
    sprite_2d.show()
    lives = 3
    change_state(ALIVE)
    shield = max_shield

    
