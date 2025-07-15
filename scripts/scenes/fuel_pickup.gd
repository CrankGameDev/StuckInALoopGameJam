extends Area2D

@onready var animation: AnimationPlayer = $Animation

@export var capacity: float = 20.0

@onready var amount: float = capacity


func _ready() -> void:
	animation.play(&"spin")


func _on_body_entered(body: Node2D) -> void:
	var player: Player = body as Player
	var fuel: FuelComponent = player.get_node(^"FuelComponent")
	var fuel_space: float = fuel.get_space()
	if fuel_space > 0.0:
		var transfer_quantity: float = minf(amount, fuel_space)
		if transfer_quantity > 0.0:
			amount -= transfer_quantity
			fuel.amount += transfer_quantity
			print("Transferred %1.1f. Amount = %1.1f" % [transfer_quantity, fuel.amount])
		else:
			print("Couldn't transfer.")
	if amount <= 0.0:
		body_entered.disconnect(_on_body_entered)
		amount = 0.0
		animation.play(&"pop_out")
