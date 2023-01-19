extends StaticBody2D

var size : float = 3.0

func _ready():
	var viewport_size = get_viewport().size
	
	var col_shape : CircleShape2D = CircleShape2D.new()
	col_shape.radius = size
	
	$CollisionShape2D.shape = col_shape
	
	randomize()
	
	global_transform.origin = Vector2(randf() * viewport_size.x, randf() * viewport_size.y)


func _draw():
	draw_circle(Vector2(0,0), size, Color.green)


func die():
	queue_free()
