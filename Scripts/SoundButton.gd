extends BaseButton

@onready var audio_player:AudioStreamPlayer = $AudioStreamPlayer 

func _on_button_down():
	audio_player.play()
