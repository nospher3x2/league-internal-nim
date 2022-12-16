include ../../utils/MemoryObject
include ../patchables/Offsets

type 
  GameObject* = ref object of MemoryObject

proc getHealth*(self: GameObject): float32 = 
  read[float32](self.address() + ObjectHealthOffset)