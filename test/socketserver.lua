package.cpath = "./skynet/luaclib/?.so"
package.path = "./skynet/lualib/?.lua"


local skynet = require "skynet"
local socket = require "skynet.socket"

--简单echo服务
function echo(id, addr)
    socket.start(id)
    while true do
        local str = socket.read(id)
        if str then
            skynet.error("客户端"..id, " 发送内容: ", str)
            socket.write(id, "发送给前端一段字符串")
        else
            socket.close(id)
            skynet.error("客户端"..id, " ["..addr.."]", "断开连接")
            return
        end
    end
end

--服务入口
skynet.start(function()

    local addr = "0.0.0.0"

    skynet.error("listen " .. addr)

    --记录，listen是监听方法，通过监听返回ID用来启动网络
    local id  = socket.listen(addr,8001)

    assert(id)

    socket.start(id, function(id, addr)
        skynet.error("客户端"..id, " ["..addr.."]", "已连接")
        --开启协程，处理来自客户端的数据
        skynet.fork(echo, id, addr)
    end)
end)
