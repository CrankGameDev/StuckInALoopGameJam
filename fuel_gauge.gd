extends Panel

@export var fuel_component: FuelComponent

var _last_ratio: float


func _ready() -> void:
	fuel_component.amount_changed.connect(_update.unbind(1))
	fuel_component.capacity_changed.connect(_update.unbind(1))
	_last_ratio = fuel_component.get_ratio()


func _process(delta: float) -> void:
	var burn_effect: float = material.get_shader_parameter(&"wave_burn_effect")
	if burn_effect > 0.0:
		material.set_shader_parameter(&"wave_burn_effect", maxf(0.0, burn_effect - delta / 2.0))


func _update() -> void:
	var ratio: float = fuel_component.get_ratio()
	material.set_shader_parameter(&"value", ratio)
	var diff: float = _last_ratio - ratio
	if diff > 0.0:
		var burn_effect: float = material.get_shader_parameter(&"wave_burn_effect")
		material.set_shader_parameter(&"wave_burn_effect", clampf(0.0, burn_effect + diff * 15.0, 1.25))
	_last_ratio = ratio
