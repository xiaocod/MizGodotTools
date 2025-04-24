extends CharacterBody2D


@onready var health_manager: HealthManager = $HealthManager
@onready var health_bar: ProgressBar = $HealthBar


func _ready() -> void:
	health_manager.health_updated.connect(on_health_updated)
	health_manager.on_health_updated()

func on_health_updated(cur_health, max_health):
	health_bar.max_value = max_health
	health_bar.value = cur_health

func get_save_data() -> Dictionary:
	return {
		"health_manager": health_manager.get_save_data()
	}

func load_save_data(save_data: Dictionary):
	if "health_manager" in save_data:
		health_manager.load_save_data(save_data.health_manager)
