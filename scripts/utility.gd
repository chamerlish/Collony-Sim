extends Node
# for everything stat

signal fish_updated
var amount_fish: int:
	set(new_amount):
		fish_updated.emit(new_amount)
		amount_fish = new_amount
