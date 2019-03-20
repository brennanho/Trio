shader_type canvas_item;
uniform float scaler = 10.0;

void vertex() {
	VERTEX.x += cos(TIME + VERTEX.x) * scaler;
	//VERTEX.y += sin(TIME + VERTEX.y + VERTEX.x/2.0) * scaler;
}	