extends Label

func _ready() -> void:
	Utility.fish_updated.connect(update_text)
	

func update_text(new_text: int):
	text = str(new_text)
