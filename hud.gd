extends CanvasLayer
signal start_game
@onready var start_button = $VBoxContainer/StartButton

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
 $Message.text = text
 $Message.show()
 $Timer.start()

func _on_timer_timeout() -> void:
  $Message.hide()

func show_game_over():
 show_message("Game Over")
 await $Timer.timeout
 $StartButton.show()
 $Message.text = "Coin Dash!"
 $Message.show()


func _on_start_button_pressed() -> void:
 $VBoxContainer.hide()
 start_game.emit()
