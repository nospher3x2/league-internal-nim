import ../patchables/Offsets

type ChatFunction = proc (ChatInstance: ByteAddress, text: cstring, format: int): int {.gcsafe, thiscall.}

type
  ChatClient* = ref object
    address: ByteAddress
    chatInstance: ByteAddress
         
    sendChatFunction: ChatFunction
    printChatFunction: ChatFunction

proc init*(self: ChatClient, address: ByteAddress) =
  self.address = address
  self.chatInstance = cast[ByteAddress](self.address + Offsets.ChatInstanceOffset)
  self.sendChatFunction = cast[ChatFunction](self.address + Offsets.SendChatFunction)
  self.printChatFunction = cast[ChatFunction](self.address + Offsets.PrintChatFunction)

proc isOpen*(self: ChatClient): bool =
  cast[bool](self.chatInstance + 0x6BC)
proc sendChat*(self: ChatClient, message: string): int =
  self.sendChatFunction(self.chatInstance, message, 1)

proc printChat*(self: ChatClient, message: string, format: int): int =
  self.printChatFunction(self.chatInstance, message, 1)