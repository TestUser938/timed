extends Node

@warning_ignore("unused_signal")
signal action(type: String)
@warning_ignore("unused_signal")
signal level(index: int, bonus: bool)
@warning_ignore("unused_signal")
signal log_text(text: String)

@warning_ignore("unused_signal")
signal hud(element: String, value: Variant)

@warning_ignore("unused_signal")
signal save()
@warning_ignore("unused_signal")
signal reload(clean: bool)
