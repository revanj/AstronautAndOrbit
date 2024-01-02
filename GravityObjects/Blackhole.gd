@tool
extends GravityObject

# rewrite the gravity vector to instead accelerate
# along the arrow directions
func get_gravity_vector(pos:Vector2, time: float) -> Vector2:
	var r = (global_position - pos).length()
	if r > effect_radius:
		return Vector2.ZERO
	if r < death_radius:
		return Vector2(NAN, NAN)
	var radial_vec = pos - (global_position).normalized()
	var accel_vec = radial_vec.rotated(-PI / 8 * 7)
	return accel_vec * 5
