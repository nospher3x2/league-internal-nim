import ./objects/GameObject
import ./patchables/Offsets

type ChatFunction = proc (ChatInstance: ByteAddress, text: cstring, format: int): int {.gcsafe, thiscall.}

type
  Game* = ref object
    address*: ByteAddress
    version: cstring

    localPlayer: GameObject

    hudInstance: ByteAddress
    chatInstance: ByteAddress
    zoomInstance: ByteAddress

    sendChatFunction: ChatFunction
    printChatFunction: ChatFunction

proc init*(self: Game, baseAddress: ByteAddress): void =
  self.address = baseAddress

  self.version = cast[cstring](self.address + Offsets.GameVersionOffset)
  self.localPlayer = cast[GameObject](self.address + Offsets.LocalPlayerInstanceOffset)

  self.hudInstance = cast[ByteAddress](self.address + Offsets.HudInstanceOffset)
  self.chatInstance = cast[ByteAddress](self.address + Offsets.ChatInstanceOffset)
  self.zoomInstance = cast[ByteAddress](self.address + Offsets.ZoomInstanceOffset)

  self.sendChatFunction = cast[ChatFunction](self.address + Offsets.SendChatFunction)
  self.printChatFunction = cast[ChatFunction](self.address + Offsets.PrintChatFunction)

proc getVersion*(self: Game): cstring =
  self.version

proc getTime*(self: Game): float64 =
  cast[float64](self.address + Offsets.GameTimeOffset)

proc getLocalPlayer*(self: Game): GameObject =
  self.localPlayer

proc sendChat*(self: Game, message: string): int =
  self.sendChatFunction(self.chatInstance, message, 1)

proc printChat*(self: Game, message: string, format: int): int =
  self.printChatFunction(self.chatInstance, message, 1)

var instance*: Game