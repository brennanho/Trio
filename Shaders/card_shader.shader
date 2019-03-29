shader_type canvas_item;
uniform float scaler = 10.0;

void vertex() {
	VERTEX.x += cos(TIME + VERTEX.x) * scaler;
}	