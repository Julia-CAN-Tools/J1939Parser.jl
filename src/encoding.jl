# J1939 encoding - implements CANUtils interface

"""
    CU.encode(message::CanMessage, sigdict::AbstractDict{String,<:Real}) -> CanFrame

Encode signal values into a CAN frame using the J1939 message definition.

Implements the CANUtils interface for CanMessage.
"""
function CU.encode(message::CanMessage, sigdict::AbstractDict{String,<:Real})
    data_g = UInt64(0)

    for sig in message.signals
        haskey(sigdict, sig.name) || throw(KeyError(sig.name))
        sig.scaling == 0.0 && throw(ArgumentError("Signal scaling must be non-zero"))

        raw = (sigdict[sig.name] - sig.offset) / sig.scaling
        raw = raw < 0 ? 0.0 : raw
        sigbits = UInt64(round(raw))
        data_g = add_signal(data_g, sigbits, sig)
    end

    payload = uint_to_payload(data_g)

    return CanFrame(encode_can_id(message.canid), payload)
end

"""
    CU.create_signal_dict(messages::Vector{CanMessage}) -> Dict{String,Float64}

Create a signal dictionary with all signal names from the J1939 messages.

Implements the CANUtils interface for Vector{CanMessage}.
"""
function CU.create_signal_dict(messages::Vector{CanMessage})
    sigdict = Dict{String,Float64}()

    for message in messages
        for sig in message.signals
            sigdict[sig.name] = 0.0
        end
    end

    return sigdict
end

"""
    create_signal_dict_storage(messages::Vector{CanMessage})

Create a storage dictionary for signal history.
"""
function create_signal_dict_storage(messages::Vector{CanMessage})
    store = Dict{String,Vector{Float64}}()

    for message in messages
        for sig in message.signals
            store[sig.name] = Float64[]
        end
    end

    return store
end
