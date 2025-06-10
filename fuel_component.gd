@tool
class_name FuelComponent
extends Node

signal amount_changed(new_amount: float)
signal capacity_changed(new_capacity: float)

@export var amount: float = 100.0 : set = set_amount
@export var capacity: float = 100.0 : set = set_capacity


func set_amount(value: float) -> void:
	var last_amount: float = amount
	amount = clampf(value, 0.0, capacity)
	if amount != last_amount:
		amount_changed.emit(amount)


func set_capacity(value: float) -> void:
	var last_capacity: float = capacity
	capacity = maxf(value, 0.0)
	if last_capacity != capacity:
		capacity_changed.emit()
	amount = minf(amount, capacity)


func get_ratio() -> float:
	return amount / capacity
