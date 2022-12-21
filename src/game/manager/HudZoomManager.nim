import ../patchables/Offsets
import strutils

type
  HudZoomManager* = ref object
    address: ByteAddress
    zoomInstance: ByteAddress

proc init*(self: HudZoomManager, address: ByteAddress) =
  self.address = address
  self.zoomInstance = cast[ptr ByteAddress](self.address + Offsets.ZoomInstanceOffset)[]
  echo toHex(self.zoomInstance)

proc getCheatDetectionStatus*(self: HudZoomManager): bool =
  cast[ptr bool](self.address + 0x315F904)[]

proc patchCheatDetection*(self: HudZoomManager): void =
  cast[ptr bool](self.address + 0x315F904)[] = true

proc getZoomValue*(self: HudZoomManager): cfloat =
  cast[cfloat](self.zoomInstance + 0x20)

proc changeZoomValue*(self: HudZoomManager, zoom: cfloat): void =
  cast[ptr cfloat](self.zoomInstance + 0x20)[] = zoom