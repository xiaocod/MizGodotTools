class_name BloodSpawner extends Node2D

## This node spawns blood clouds and flings splatters
## controlled from HealthManager class

const BLOOD_SPLATTER = preload("res://effects/blood_splatter/blood_splatter.tscn")
const BLOOD_CLOUD = preload("res://effects/blood_splatter/blood_cloud.tscn")

@export var max_splatter_dist = 130.0
@export var blood_wall_offset = 15.0

@export var max_splatter_count = 5
@export var min_splatter_count = 3

@export var blood_spray_arc = 180.0

@onready var ray_cast_2d = $RayCast2D


func splatter_blood(dir = Vector2.DOWN):
	var splatter_count = randi_range(min_splatter_count, max_splatter_count)
	for i in splatter_count:
		spawn_blood(get_splatter_offset(dir), i%3==0)

func splatter_extra_blood(dir = Vector2.DOWN):
	var splatter_count = randi_range(min_splatter_count, max_splatter_count) * 2
	for i in splatter_count:
		spawn_blood(get_splatter_offset(dir) * 1.5, i%3==0)

func get_splatter_offset(dir = Vector2.DOWN):
	var splatter_dir = dir.rotated(deg_to_rad(randf_range(-blood_spray_arc, blood_spray_arc)/2.0))
	var splatter_dist = randf_range(0.0, max_splatter_dist)
	return splatter_dir * splatter_dist

func spawn_blood(pos_offset=Vector2.ZERO, play_splatter_sound=false):
	var blood_splatter = BLOOD_SPLATTER.instantiate()
	blood_splatter.add_to_group("instanced")
	get_tree().get_root().add_child(blood_splatter)
	
	var goal_pos = global_position + pos_offset
	ray_cast_2d.enabled = true
	ray_cast_2d.target_position = ray_cast_2d.to_local(goal_pos)
	ray_cast_2d.force_raycast_update()
	if ray_cast_2d.is_colliding():
		goal_pos = ray_cast_2d.get_collision_point()
	ray_cast_2d.enabled = false
	
	var offset = goal_pos.direction_to(global_position) * blood_wall_offset
	blood_splatter.fling_blood(global_position, goal_pos + offset, play_splatter_sound)

func spawn_blood_cloud():
	var blood_cloud = BLOOD_CLOUD.instantiate()
	blood_cloud.global_position = global_position
	get_tree().get_root().add_child(blood_cloud)
