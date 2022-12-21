type 
  MemoryObject* = ptr object of RootObj
    initialized: int32
    address: ByteAddress
    
proc read[T](self: MemoryObject, address: ByteAddress): T =
  if(self.initialized != 200): # HAHAHA NIM GAMB BECAUSE NOT POSSIBLE SET DEFAULT VALUE
    self.address = cast[ptr ByteAddress](self)[]
    self.initialized = 200

  return cast[ptr T](self.address + address)[]