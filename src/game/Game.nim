import ./objects/GameObject
import ./patchables/Offsets

type ChatFunction = proc (ChatInstance: ByteAddress, text: cstring, format: int): int {.gcsafe, thiscall.}

type
  Game* = ref object
    baseAddress: ByteAddress

    localPlayer: GameObject

    hudInstance: ByteAddress
    chatInstance: ByteAddress

    sendChatFunction: ChatFunction
    printChatFunction: ChatFunction

proc init*(self: Game, baseAddress: ByteAddress): void =
  self.baseAddress = baseAddress

  self.localPlayer = cast[GameObject](self.baseAddress + Offsets.LocalPlayerOffset)
  self.chatInstance = cast[ByteAddress](self.baseAddress + Offsets.ChatInstanceOffset)

  self.sendChatFunction = cast[ChatFunction](self.baseAddress + Offsets.SendChatFunction)
  self.printChatFunction = cast[ChatFunction](self.baseAddress + Offsets.PrintChatFunction)

proc getGameTime*(self: Game): float =
  cast[float](self.baseAddress + Offsets.GameTimeOffset)
  
proc getLocalPlayer*(self: Game): GameObject =
  self.localPlayer

proc sendChat*(self: Game, message: cstring): int =
  self.sendChatFunction(self.chatInstance, message, 1)

proc printChat*(self: Game, message: cstring, format: int): int =
  self.printChatFunction(self.chatInstance, message, 1)