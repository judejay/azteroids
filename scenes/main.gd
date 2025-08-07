extends Node2D
@onready var hud: CanvasLayer = $HUD

@export var rock_scene : PackedScene
var screensize = Vector2.ZERO
var level = 0
var score = 0
var playing = false

func _ready():
 screensize = get_viewport().get_visible_rect().size




func _process(delta: float) -> void:
    if not playing:
      return
    if get_tree().get_nodes_in_group("rocks").size() == 0:
     new_level()

func spawn_rock(size, pos=null, vel=null):
 if pos == null:
  $Rockpath/Rockspawn.progress = randi()
  pos = $Rockpath/Rockspawn.position
 if vel == null:
  vel = Vector2.RIGHT.rotated(randf_range(0, TAU)) * randf_range(50, 215)
 var r = rock_scene.instantiate()
 r.screensize = screensize
 r.start(pos, vel, size)
 call_deferred("add_child", r)
 r.exploded.connect(self._on_rock_exploded)

func _on_rock_exploded(size, radius, pos, vel):
 if size <= 1:
   return
 for offset in [-1, 1]:
   var dir = $Player.position.direction_to(pos).orthogonal() * offset
   var newpos = pos + dir * radius
   var newvel = dir * vel.length()* 1.1
   spawn_rock(size - 1, newpos, newvel)


func new_game():
 get_tree().call_group("rocks", "queue_free")
 level = 0
 score = 0
 hud.update_score(score)
 hud.show_message("Get Ready!")
 $Player.reset()
 await $HUD/Timer.timeout
 playing = true

func new_level():
 level += 1
 hud.show_message("Wave %s" % level)
 for i in level:
  spawn_rock(3)

func game_over():
 playing = false
 hud.game_over()
