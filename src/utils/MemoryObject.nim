type 
  MemoryObject* = ref object of RootObj

proc read[T](address: ByteAddress): T =
  cast[ptr T](address)[]

method address(self: MemoryObject): ByteAddress {.base.} = 
  read[ByteAddress](cast[ByteAddress](self))