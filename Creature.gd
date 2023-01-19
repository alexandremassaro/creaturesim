extends KinematicBody2D


enum state {
	IDLE,
	HUNTING,
	ROAMING
}


var field_of_view : float # range between 0 and 360 degrees
var line_of_sight : float = 200.0 # distance that it can see
var speed : float = 100.0 # How fast the creature moves
var size : int = 20.0

# The creature will die when lifetime is smaller than time_since_birth
var lifetime : int # Total time in game ticks the creature can live
var time_since_birth : int = 0 # How long (in game_ticks) the creature has been alive.

var target = [] # Position on the screen the creature will move towards

var behavior = state.IDLE


func roam():
	var viewport_size = get_viewport().size
	randomize()
	$roam_target.global_transform.origin = Vector2(randf() * viewport_size.x , randf() * viewport_size.y)
	target.append($roam_target)


func _ready():
	set_up_hitbox()
	set_up_detection()
	behavior = state.ROAMING
	roam()


func set_up_detection():
	var col_shape : CircleShape2D = CircleShape2D.new()
	col_shape.radius = line_of_sight
	$detection/detection_shape.shape = col_shape

func set_up_hitbox():
	var col_shape : CircleShape2D = CircleShape2D.new()
	col_shape.radius = size
	$hitbox.shape = col_shape


func set_up_attack_range():
	var col_shape : CircleShape2D = CircleShape2D.new()
	col_shape.radius = size + 1
	$attack_range/attack_range_shape.shape = col_shape

func move_to_target():
	var distance_to_target : Vector2	
	
	distance_to_target = target[0].global_transform.origin - global_transform.origin
	
	var direction = (distance_to_target).normalized()
	var velocity = direction * speed
	move_and_slide(velocity)
	
	if global_transform.origin.distance_to(target[0].global_transform.origin) <= size + 5:
		if behavior == state.ROAMING:
			target.pop_front()
			roam()
		elif behavior == state.HUNTING:
			eat_pellet(target.pop_front())
			if target.size() <= 0:
				behavior = state.ROAMING
				roam()


func _physics_process(delta):
	move_to_target()


func _draw():
	draw_circle(Vector2(0,0), size, Color.red)


func _on_detection_body_entered(body):
	if body.is_in_group("plants") :
		if behavior == state.ROAMING:
			target.pop_front()
			behavior = state.HUNTING
		target.append(body)
		print(target)


func eat_pellet(body):
	body.die()
