import ../patchables/Offsets

type GetPingFunction = proc (netClientInstance: ByteAddress): cint {.gcsafe, thiscall.}

type
  NetClientManager* = ref object
    address: ByteAddress

    netClientInstance: ByteAddress
    getPingFunction: GetPingFunction

proc init*(self: NetClientManager, address: ByteAddress) =
  self.address = address

  self.netClientInstance = cast[ptr ByteAddress](self.address + Offsets.NetClientInstanceOffset)[]
  self.getPingFunction = cast[GetPingFunction](self.address + Offsets.GetPingFunctionOffset)

proc getPing*(self: NetClientManager): cint =
  self.getPingFunction(self.netClientInstance)