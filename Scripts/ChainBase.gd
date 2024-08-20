extends Node2D

@export_node_path() var claw_path

@onready var claw = get_node(claw_path) as Node2D
@onready var base_particles: GPUParticles2D = $BaseParticles

func _process(delta: float) -> void:
	if !claw.input_enabled: return
	
	position.x = lerp(position.x, claw.position.x, delta)

func set_particles_active(active:bool) ->void:
	base_particles.emitting = active
	
func reset() ->void:
	position.x = 80.0#claw.position.x
