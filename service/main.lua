local skynet = require "skynet"

local max_client = 64

skynet.start(function()
	skynet.error("妈的它服务器启动跑到这里了")
	if not skynet.getenv "daemon" then
		local console = skynet.newservice("console")
	end
	skynet.newservice("debug_console",8000)
	skynet.newservice("socketserver")
	skynet.error("Watchdog listen on", 8888)
	skynet.exit()
end)
