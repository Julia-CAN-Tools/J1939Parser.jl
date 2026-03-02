# J1939 decoding - implements CANUtils interface

"""
    CU.decode!(frame::CanFrame, message::CanMessage, sigdict::Dict{String,Float64})

Decode a CAN frame using the J1939 message definition.

Implements the CANUtils interface for CanMessage.
"""
function CU.decode!(frame::CanFrame, message::CanMessage, sigdict::Dict{String,Float64})
    data_g = data_to_int(frame.data)
    for sig in message.signals
        sigbits = extract_signal(data_g, sig)
        sigdict[sig.name] = Float64(sigbits) * sig.scaling + sig.offset
    end
    return sigdict
end

"""
    CU.match_and_decode!(frame::CanFrame, messages::Vector{CanMessage}, sigdict::Dict{String,Float64})

Find a matching J1939 message and decode.

Matches by PF, PS, SA and multiplexer bytes if defined.
Implements the CANUtils interface for Vector{CanMessage}.
"""
function CU.match_and_decode!(frame::CanFrame, messages::Vector{CanMessage}, sigdict::Dict{String,Float64})
    cid = decode_can_id(frame.canid)

    for message in messages
        # Match by PF, PS, SA
        if cid.pf == message.canid.pf && cid.ps == message.canid.ps && cid.sa == message.canid.sa
            CU.decode!(frame, message, sigdict)
            return true
        end
    end

    return false
end
