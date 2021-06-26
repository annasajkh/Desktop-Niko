extends Node2D

onready var text = $RichTextLabel;
onready var text_sound = $TextSound;
onready var speak_sound_timer  = $SpeakSoundTimer;
onready var wait_timer  = $WaitTimer;

var speak_finish : bool;
var start : bool = false;


func speak(t : String) -> void:
	OS.window_size = Vector2(184,100)
	text.text = t;
	text.show();
	start = true;
	speak_finish = false;
	print("call")

func _process(delta: float) -> void:
	if start:
		if text.percent_visible < 1:
			text.percent_visible += 0.25 / text.text.length();
			if speak_sound_timer.is_stopped():
				speak_sound_timer.start();
		else:
			speak_sound_timer.stop();
			wait_timer.start();
			start = false

func _on_SpeakSoundTimer_timeout() -> void:
	text_sound.play();


func _on_WaitTimer_timeout() -> void:
	text.percent_visible = 0;
	text.hide();
	speak_finish = true;
