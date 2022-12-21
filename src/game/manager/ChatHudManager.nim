import ../patchables/Offsets

type ChatMessageFunction = proc (ChatInstance: ByteAddress, text: cstring, format: int): int {.gcsafe, thiscall.}

type
  ChatHudManager* = ref object
    address: ByteAddress
    chatInstance: ByteAddress
         
    sendChatFunction: ChatMessageFunction
    printChatFunction: ChatMessageFunction

proc init*(self: ChatHudManager, address: ByteAddress) =
  self.address = address
  self.chatInstance = cast[ByteAddress](self.address + Offsets.ChatInstanceOffset)
  self.sendChatFunction = cast[ChatMessageFunction](self.address + Offsets.SendChatFunction)
  self.printChatFunction = cast[ChatMessageFunction](self.address + Offsets.PrintChatFunction)

proc isOpen*(self: ChatHudManager): bool =
  cast[bool](self.chatInstance + 0x6BC)
  
proc sendMessage*(self: ChatHudManager, message: string): int =
  self.sendChatFunction(self.chatInstance, message, 1)

proc printMessage*(self: ChatHudManager, message: string, format: int): int =
  self.printChatFunction(self.chatInstance, message, 1)