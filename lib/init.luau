--[[                Signal Module               ]]--
--[[              Author: mensonrbx             ]]--

local Connection = require(script:WaitForChild("Connection"))
type Connection = Connection.Connection

local Signal = {}
Signal.__index = Signal

type self = {
    _connections: {[number]: Connection},
}

export type Signal = typeof(setmetatable({} :: self, Signal))

function Signal.new(): Signal 
    return setmetatable({
        _connections = {},
    } :: self, Signal)
end

function Signal.Connect(self: self, callback: (any) -> any): Connection
    local newConnection = Connection.new(callback)
    table.insert(self._connections, newConnection)
    return newConnection
end

function Signal.Once(self: self, callback: (any) -> any): Connection
    local newConnection = Connection.new(callback)
    newConnection.once = true
    table.insert(self._connections, newConnection)
    return newConnection
end

function Signal.Wait(self: self, callback: (any) -> any): ()
    local newConnection = Connection.new(callback)
    newConnection.wait = true
    table.insert(self._connections, newConnection)
    repeat task.wait() until not newConnection.enabled
end

function Signal.Fire(self: self, ...: any): ()
    local currIter = 1
    while currIter <= #self._connections do
        local currConnection = self._connections[currIter] :: Connection
        if not currConnection.enabled then
            table.remove(self._connections, currIter)
        else
            task.spawn(currConnection.callback, ...)
            if currConnection.once or currConnection.wait then
                currConnection:Disconnect()
                table.remove(self._connections, currIter)
            else
                currIter += 1
            end
        end
    end
end

return Signal

