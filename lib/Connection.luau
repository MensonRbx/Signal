local Connection = {}
Connection.__index = Connection

type self = {
    enabled: boolean,
    once: boolean,
    wait: boolean,
    callback: ((any) -> any),
}

export type Connection = typeof(setmetatable({} :: self, Connection))

function Connection.new(callback: (any) -> any): Connection
    return setmetatable({
        enabled = true,
        once = false,
        wait = false,
        callback = callback
    } :: self, Connection)
end

function Connection.Disconnect(self: self): ()
    self.enabled = false
    setmetatable(self, nil)
end

Connection.Destroy = Connection.Disconnect

return Connection

