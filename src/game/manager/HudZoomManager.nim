import ../patchables/Offsets

type
  HudZoomManager* = ref object
    address: ByteAddress
    zoomInstance: ByteAddress

proc init*(self: HudZoomManager, address: ByteAddress) =
  self.address = address
  self.zoomInstance = cast[ptr ByteAddress](self.address + Offsets.ZoomInstanceOffset)[]

proc cheatDetectionIsPatched*(self: HudZoomManager): bool =
  cast[ptr bool](self.address + 0x315F904)[]

proc patchCheatDetection*(self: HudZoomManager): void =
  cast[ptr bool](self.address + 0x315F904)[] = true

proc getZoomValue*(self: HudZoomManager): cfloat =
  cast[ptr cfloat](self.zoomInstance + 0x20)[]

proc changeZoomValue*(self: HudZoomManager, zoom: cfloat): void =
  if self.cheatDetectionIsPatched():
    cast[ptr cfloat](self.zoomInstance + 0x20)[] = zoom