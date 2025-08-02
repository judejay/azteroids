extends Node2D

@export var rock_scene : PackedScene
var screensize = Vector2.ZERO

func _ready():
 screensize = get_viewport().get_visible_rect().size
 for i in 6:
  spawn_rock(3)


func _process(delta: float) -> void:
 pass

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

##func _on_game_timer_timeout() -> void:
 ##time_left -= 1
 #$HUD.update_timer(time_left)
 #if time_left <= 0:
  #game_over()
