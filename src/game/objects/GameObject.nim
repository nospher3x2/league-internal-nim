include ../../utils/MemoryObject
include ../patchables/Offsets

type GameObjectTeam* = enum
  Unknown = 0
  Order = 100
  Chaos = 200
  Neutral = 300

type 
  GameObject* = ref object of MemoryObject

proc getIndex*(self: GameObject): int32 = 
  read[int32](self, ObjectIndexOffset)

proc getNetworkId*(self: GameObject): int32 = 
  read[int32](self, ObjectNetworkIDOffset)

proc getTeam*(self: GameObject): GameObjectTeam =
  read[GameObjectTeam](self, ObjectTeamOffset)

proc getLevel*(self: GameObject): int32 = 
  read[int32](self, ObjectLevelOffset)

proc getHealth*(self: GameObject): float32 = 
  read[float32](self, ObjectHealthOffset)

proc getMaxHealth*(self: GameObject): float32 = 
  read[float32](self, ObjectMaxHealthOffset)

proc getRecallState*(self: GameObject): int32 = 
  read[int32](self, ObjectRecallStateOffset)