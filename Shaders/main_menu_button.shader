shader_type canvas_item;
uniform float scaler = 7.5;

void vertex() {
	VERTEX.x += cos(TIME + VERTEX.x + VERTEX.y/2.0) * scaler;
	VERTEX.y += sin(TIME + VERTEX.y + VERTEX.x/2.0) * scaler;	
}