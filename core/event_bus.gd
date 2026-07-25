extends Node

signal action(type: String)
signal level(index: int, bonus: bool)
signal log_text(text: String)

signal hud(element: String, value: Variant)

signal save()
signal reload(clean: bool)
