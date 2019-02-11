extends CanvasLayer

#Tutorial: https://fede0d.github.io/blog/2016/02/07/Godot-Extra-Tips-2.html
# STORE THE SCENE PATH
var path = ""

# PUBLIC FUNCTION. CALLED WHENEVER YOU WANT TO CHANGE SCENE
func fade_to(scn_path):
	self.path = scn_path # store the scene path
	self.layer = 2
	get_node("Background").get_node("AnimationPlayer").play("transition") # play the transition animation
	get_node("Background2").get_node("AnimationPlayer").play("transition") # play the transition animation

# PRIVATE FUNCTION. CALLED AT THE MIDDLE OF THE TRANSITION ANIMATION
func change_scene():
	if path != "":
		get_tree().change_scene(path)