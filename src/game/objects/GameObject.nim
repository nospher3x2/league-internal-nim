include ../../utils/MemoryObject
include ../patchables/Offsets

type GameObjectTeam* = enum
  Unknown = 0
  Order = 100
  Chaos = 200
  Neutral = 300

type 
  GameObject* = ref object of MemoryObject
    vtable: ptr array[0..128, pointer]

proc getIndex*(self: GameObject): int32 = 
  read[int32](self.address() + ObjectIndexOffset)

proc getNetworkId*(self: GameObject): int32 = 
  read[int32](self.address() + ObjectNetworkIDOffset)

proc getTeam*(self: GameObject): GameObjectTeam =
  read[GameObjectTeam](self.address() + ObjectTeamOffset)

proc getHealth*(self: GameObject): float32 = 
  read[float32](self.address() + ObjectHealthOffset)

proc getMaxHealth*(self: GameObject): float32 = 
  read[float32](self.address() + ObjectMaxHealthOffset)