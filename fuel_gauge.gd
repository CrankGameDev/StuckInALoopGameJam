extends Panel

@export var fuel_component: FuelComponent

var arrow_visibility: float = 0.0 :
	get: return material.get_shader_parameter(&"arrow_visibility")
	set(value): material.set_shader_parameter(&"arrow_visibility", value)

const _ARROW_TIMER_NAME: StringName = &"ArrowTimer"
const _ARROW_TIMER_PATH: NodePath = NodePath(_ARROW_TIMER_NAME)

var _arrow_timer: Timer
var _arrow_tween: Tween

var _last_ratio: float


func _ready() -> void:
	fuel_component.amount_changed.connect(_update.unbind(1))
	fuel_component.capacity_changed.connect(_update.unbind(1))
	_last_ratio = fuel_component.get_ratio()

	_arrow_timer = Timer.new()
	_arrow_timer.name = _ARROW_TIMER_NAME
	_arrow_timer.one_shot = true
	_arrow_timer.timeout.connect(hide_arrows)
	add_child(_arrow_timer, false, INTERNAL_MODE_FRONT)


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
		show_arrows()
		_arrow_timer.start(0.25)
	_last_ratio = ratio


func _reset_arrow_tween() -> void:
	if _arrow_tween and _arrow_tween.is_running():
		_arrow_tween.kill()
	_arrow_tween = create_tween()


func show_arrows() -> void:
	if arrow_visibility < 0.5:
		_reset_arrow_tween()
		_arrow_tween.tween_property(self, ^":arrow_visibility", 0.5, 0.25)


func hide_arrows() -> void:
	if arrow_visibility > 0.0:
		_reset_arrow_tween()
		_arrow_tween.tween_property(self, ^":arrow_visibility", 0.0, 0.25)
