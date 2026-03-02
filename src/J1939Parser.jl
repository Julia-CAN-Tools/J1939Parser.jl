module J1939Parser

import CANUtils as CU
using CANUtils: CanFrame, Signal, AbstractCanMessage
using CANUtils: extract_bits, extract_signal, data_to_int
using CANUtils: add_bits, add_signal, uint_to_payload
using CANUtils: decode!, match_and_decode!, encode, create_signal_dict

using Printf

# J1939 bit masks
const PRIORITY_MASK = UInt32(0x1c000000)
const EDP_MASK = UInt32(0x02000000)
const DP_MASK = UInt32(0x01000000)
const PF_MASK = UInt32(0x00ff0000)
const PS_MASK = UInt32(0x0000ff00)
const SA_MASK = UInt32(0x000000ff)
const PGN_MASK = UInt32(0x00ffff00)

# Include type definitions
include("types/CanId.jl")
include("types/CanMessage.jl")

# Include implementations
include("decoding.jl")
include("encoding.jl")

# Re-export CANUtils types for convenience
export CanFrame, Signal

# Export J1939-specific types
export CanId, CanMessage

# Export J1939-specific functions
export encode_can_id, decode_can_id

# Export interface implementations (also available via CU.decode! etc.)
export decode!, match_and_decode!, encode, create_signal_dict
export create_signal_dict_storage

end 
