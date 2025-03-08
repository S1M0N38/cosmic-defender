-- File: conf.lua
-- LÖVE configuration file

function love.conf(t)
	t.title = "Cosmic Defender"
	t.version = "11.3"
	t.window.width = 800
	t.window.height = 600
	t.window.resizable = false
	t.window.vsync = true

	t.modules.joystick = false
	t.modules.physics = false
	t.modules.video = false

	t.console = false
end
