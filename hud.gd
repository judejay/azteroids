extends CanvasLayer
signal start_game
@onready var start_button = $VBoxContainer/StartButton
@onready var lives_counter = $MarginContainer/HBoxContainer/LivesContainer.get_children()
@onready var message = $VBoxContainer/Message

func update_score(value):
 $MarginContainer/Score.text = str(value)

func update_timer(value):
  $MarginContainer/Time.text = str(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
 pass # Replace with function body.


# Called  every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
 pass

func show_message(text):
 message.text = text
 message.show()
 $Timer.start()

func _on_timer_timeout() -> void:
  message.hide()

func game_over():
 show_message("Game Over")
 await $Timer.timeout
 start_button.show()

func update_lives(value):
    for item in 3:
        lives_counter[item].visible = value > item

func _on_start_button_pressed() -> void:
 start_button.hide()
 start_game.emit()
