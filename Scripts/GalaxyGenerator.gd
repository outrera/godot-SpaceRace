# Galaxy Generator
extends Reference

var Galaxy = preload("res://Scripts/Model/Galaxy.gd")
var StarLane = preload("res://Scripts/Model/StarLane.gd")
var StarSystemGenerator = preload("res://Scripts/StarSystemGenerator.gd")

func random_size():
	return Utils.rand_pick_from_array(mapdefs.galaxy_sizes)
	pass

# TODO: Split into init, stars and star system phases
func generate_galaxy(size):
	var galaxy = generate_stars(size)
	generate_star_systems(galaxy)
	return galaxy

# only generate stars
func generate_stars(size):
	if size == null or size == "":
		size = random_size()
		
	var galaxy = Galaxy.new()
	var sys_gen = StarSystemGenerator.new()
	var used_star_names = []
	sys_gen.used_star_names = used_star_names
	for s in range(mapdefs.galaxy_size[size]):
		# generate star without planets
		var sys = sys_gen.generate_star(s)
		# generate system position
		var sys_pos = Utils.rand_v3_in_unit_sphere(1)
		# store system
		galaxy.systems[sys_pos] = sys
		pass
	return galaxy

# only generate systems when stars are done
func generate_star_systems(galaxy):
	var sys_gen = StarSystemGenerator.new()
	for sys in galaxy.systems:
		var system = galaxy.systems[sys]
		sys_gen.generate_planets(system)
	pass
	
func connect_star_systems(galaxy):
	var first = true
	# TODO: walk through the systems and spawn connections
	for sys in galaxy.systems:
		var system = galaxy.systems[sys]
		# find the closest unconnected system
		var minimum = 100
		var closest_pos = null
		var closest_sys = null
		for other in galaxy.systems:
			var other_system = galaxy.systems[other]
			if sys != other:
				var distance = (other - sys).length()
				if distance < minimum:
					closest_pos = other
					closest_sys = other_system
					minimum = distance
		# conjure up a star lane
		if closest_pos != null and closest_sys != null:
			var lane = StarLane.new()
			lane.connects = [system, closest_sys]
			lane.galactic_positions = [sys, closest_pos]
			if not lane.connects in galaxy.lanes:
				galaxy.lanes[lane.connects] = lane
			var from_to = (closest_pos - sys).normalized() * 5
			var to_from = (sys - closest_pos).normalized() * 5
			lane.directions = [from_to, to_from]
			lane.positions = [from_to, to_from]
			if first:
				#print(from_to)
				#print(to_from)
				first = false
			system.lanes[from_to] = lane
			closest_sys.lanes[to_from] = lane
	pass

# plunk races into random systems
func distribute_races(galaxy):
	pass