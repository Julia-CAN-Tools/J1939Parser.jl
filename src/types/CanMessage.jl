"""
    CanMessage <: AbstractCanMessage

J1939 message definition with multiplexing support.

# Fields
- `name::String`: Message name
- `canid::CanId`: J1939 CAN identifier
- `signals::Vector{Signal}`: Signal definitions
"""
struct CanMessage <: AbstractCanMessage
    name::String
    canid::CanId
    signals::Vector{Signal}

    function CanMessage(name::AbstractString, canid::CanId, signals::Vector{Signal})
        return new(String(name), canid, copy(signals))
    end

    function CanMessage()
        return new("", CanId(), Signal[])
    end
end

function Base.show(io::IO, msg::CanMessage)
    println(io)
    println(io, "=== CanMessage: ", msg.name, " ===")
    println(io, "  CAN ID: ", msg.canid)
    println(io, "  Signals: ", length(msg.signals))
    for sig in msg.signals
        println(io, "    - ", sig.name)
    end
    return nothing
end
