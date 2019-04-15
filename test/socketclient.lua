package.cpath = "./skynet/luaclib/?.so"
package.path = "./skynet/lualib/?.lua"


local skynet = require "skynet"
local socket = require "skynet.socket"

local name = ... or ""

function _read(id)
    while true do
        local str   = socket.read(id)
        if str then
            skynet.error(id, "收到服务器数据: ", str)
            socket.close(id)
            skynet.exit()
        else
            socket.close(id)
            skynet.error("断开链接")
            skynet.exit()
        end
    end
end

skynet.start(function()
    --连接到服务器
    local addr  = "0.0.0.0:8001"
    local id    = socket.open(addr)
    if not id then
        skynet.error("无法连接 "..addr)
        skynet.exit()
    end

    skynet.error("已连接")

    --启动读协程
    skynet.fork(_read, id)

    socket.write(id, "hello, "..name)
end)

print("自定义测试客户端跑通")
