shader_type canvas_item;
uniform float scaler = 2.0;

void vertex() {
	VERTEX.y += sin(TIME + VERTEX.y) * scaler;
	VERTEX.x += sin(TIME + VERTEX.x) * scaler;		
}