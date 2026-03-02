"""
    CanId

J1939 CAN identifier with priority, EDP, DP, PF, PS, SA fields.

# Fields
- `priority::UInt8`: Message priority (0-7, lower is higher priority)
- `edp::UInt8`: Extended Data Page
- `dp::UInt8`: Data Page
- `pf::UInt8`: PDU Format
- `ps::UInt8`: PDU Specific (destination address or group extension)
- `sa::UInt8`: Source Address
"""
struct CanId
    priority::UInt8
    edp::UInt8
    dp::UInt8
    pf::UInt8
    ps::UInt8
    sa::UInt8
end

"""
    CanId(priority, pf, ps, sa)

Simplified constructor with EDP=0, DP=0.
"""
function CanId(priority::Integer, pf::Integer, ps::Integer, sa::Integer)
    return CanId(UInt8(priority), UInt8(0), UInt8(0), UInt8(pf), UInt8(ps), UInt8(sa))
end

"""
    CanId(rawid::Integer)

Construct CanId by decoding a raw 29-bit CAN identifier.
"""
function CanId(rawid::Integer)
    priority = UInt8((rawid & PRIORITY_MASK) >> 26)
    edp = UInt8((rawid & EDP_MASK) >> 25)
    dp = UInt8((rawid & DP_MASK) >> 24)
    pf = UInt8((rawid & PF_MASK) >> 16)
    ps = UInt8((rawid & PS_MASK) >> 8)
    sa = UInt8(rawid & SA_MASK)
    return CanId(priority, edp, dp, pf, ps, sa)
end

CanId() = CanId(UInt32(0))

function Base.show(io::IO, canid::CanId)
    println(io)
    println(io, "---------------------")
    println(io, "    Priority: ", canid.priority)
    println(io, "    DP: ", canid.dp)
    println(io, "    EDP: ", canid.edp)
    println(io, @sprintf("    PF: 0x%02X", canid.pf))
    println(io, @sprintf("    PS: 0x%02X", canid.ps))
    println(io, @sprintf("    SA: 0x%02X", canid.sa))
    println(io, "---------------------")
    return nothing
end

"""
    encode_can_id(canid::CanId) -> UInt32

Encode a J1939 CanId to a raw 29-bit CAN identifier.
"""
function encode_can_id(canid::CanId)
    return (UInt32(canid.priority) << 26) |
           (UInt32(canid.edp) << 25) |
           (UInt32(canid.dp) << 24) |
           (UInt32(canid.pf) << 16) |
           (UInt32(canid.ps) << 8) |
           UInt32(canid.sa)
end

"""
    decode_can_id(rawid::Integer) -> CanId

Decode a raw 29-bit CAN identifier to a J1939 CanId.
"""
decode_can_id(rawid::Integer) = CanId(rawid)
