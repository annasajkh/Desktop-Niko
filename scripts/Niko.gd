extends AnimatedSprite

var speed : float = 1;

var direction : int;
onready var change_direction_timer : Timer = $ChangeDirectionTimer;
onready var speak_timer : Timer = $SpeakTimer;
onready var dialog_box : Node2D = $DialogBox;
var variant : String;
var niko_walk : bool = true;
var screen_size : Vector2;
var user_name : String;
var choice : int  = 0
var is_pointer : bool = false

func _ready() -> void:
	randomize();
	get_tree().get_root().set_transparent_background(true);
	change_direction_timer.wait_time = 1 + randi() % 9;
	speak_timer.wait_time = 100 + randi() % 60;
	speak_timer.start()
	variant = str(randi() % 5);
	change_direction_timer.start()
	direction = randi() % 4;
	screen_size = OS.get_screen_size();
	user_name = OS.get_environment("USERNAME")
	OS.alert("so your name is " + user_name,"The World Machine")
	niko_walk = false;
	speak_timer.wait_time = 100 + randi() % 500;
	OS.window_size = Vector2(184,100);
	dialog_box.speak("hello " + user_name + " nice to meet you my name is niko");


func _process(delta: float) -> void:
	if is_pointer && Input.is_mouse_button_pressed(1):
		OS.window_position = OS.window_position + self.get_local_mouse_position()

func _physics_process(_delta: float) -> void:
	if dialog_box.speak_finish && !niko_walk:
		OS.window_size = Vector2(48,64);
		direction = randi() % 4;
		niko_walk = true;
	
	if direction == 0:
		play("up" + variant);
		OS.window_position += Vector2(0, -speed);
	elif direction == 1:
		play("down" + variant);
		OS.window_position += Vector2(0, speed);
	elif direction == 2:
		play("right" + variant);
		OS.window_position += Vector2(speed,0);
	elif direction == 3:
		play("left"  + variant);
		OS.window_position += Vector2(-speed,0);
	elif direction == 4:
		frame = 0;
		animation = "down" + variant
		playing = false
		
	if OS.window_position.x > OS.get_screen_size().x - 48 :
		direction = [0,1,3][randi() % 3];
	elif OS.window_position.x < 0:
		direction = [0,1,2][randi() % 3];
	elif OS.window_position.y > OS.get_screen_size().y - 68 :
		direction = [0,2,3][randi() % 3];
	elif OS.window_position.y < 0:
		direction = [1,2,3][randi()%3];
	if niko_walk:
		OS.window_position.x = clamp(OS.window_position.x,0,OS.get_screen_size().x - 48);
		OS.window_position.y = clamp(OS.window_position.y,0,OS.get_screen_size().y - 68);
	else:
		direction = 4;
	
	if dialog_box.speak_finish && speak_timer.is_stopped():
		speak_timer.start()

func _on_ChangeDirectionTimer_timeout() -> void:
	change_direction_timer.wait_time = 1 + randi() % 9;
	if niko_walk:
		direction = randi() % 4;

func get_time() -> String:
	var time : Dictionary = OS.get_time()
	var hour : int = time.get("hour");
	if hour == 24:
		hour = 0;
	var minute : String = str(OS.get_datetime(true).get("minute")) if OS.get_datetime(true).get("minute") > 9 else "0" + str(time.get("minute"))
	return str(hour) + ":" + minute

func _on_SpeakTimer_timeout() -> void:
	if screen_size.x - 184 > OS.window_position.x && screen_size.y - 100 > OS.window_position.y:
		niko_walk = false
		speak_timer.wait_time = 100 + randi() % 6;
		variant = str(randi() % 5);
		if choice == 0:
			
			var time : String = get_time()
			var hour : int = int(time.split(":")[0])
			OS.alert(get_time(),"The World Machine");
			if hour > 21 || hour < 4:
				dialog_box.speak("you should go to sleep " + user_name + " please");
			else:
				dialog_box.speak("that's good to khow i guess");
		elif choice == 1:
			OS.alert("your battery level is " + str(OS.get_power_percent_left()) + "%","The World Machine")
			if OS.get_power_percent_left() < 30:
				dialog_box.speak("ummm.... i think you should charge it" + user_name);
			else:
				dialog_box.speak("that's good to khow i guess");
		elif choice == 2:
			OS.alert("so you're using " + OS.get_name(),"The World Machine");
			dialog_box.speak(OS.get_name() + "? what is that");
			yield(get_tree().create_timer(2),"timeout");
			OS.alert("it's an Operating System","The World Machine");
			dialog_box.speak("*confuse cat noises*");
			yield(get_tree().create_timer(1.5),"timeout");
			OS.alert("nevermind","The World Machine");
		if choice > 2:
			choice = randi()%3;
		else:
			choice +=1;
	else:
		speak_timer.start();


func _on_Area2D_mouse_entered() -> void:
	is_pointer = true



func _on_Area2D_mouse_exited() -> void:
	is_pointer = false
