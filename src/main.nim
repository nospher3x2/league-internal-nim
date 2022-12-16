{.passL: "-s -static-libgcc".}
import winim/com
import ./game/objects/GameObject
import ./game/Game

proc read*(address: ByteAddress, t: typedesc): t =
  cast[ptr t](address)[]

# type 
#   GameObject* = ref object

# proc getHealth(self: GameObject): float32 = 
#   return read(cast[ByteAddress](self) + 0xE7C, float32)

proc mainThread(hModule: HINSTANCE) =

  AllocConsole()
  discard stdout.reopen("CONOUT$", fmWrite)

  echo "oiii"

  let addressBase = GetModuleHandleA(nil)

  let game = Game()
  game.init(addressBase)
  
  let localPlayer = game.getLocalPlayer()
  echo localPlayer.getHealth()

  discard game.sendChat("oiii")
  discard game.printChat("oi amigo", 0x2)

  # let ChatInstance = read(GameModule + 0x314B094, ByteAddress)
  # echo toHex(ChatInstance)

  # let printChat = cast[PrintChat](GameModule + 0x613C20)
  # discard printChat(ChatInstance, "oii", 0x1)


proc NimMain() {.cdecl, importc.}

proc DllMain(hModule: HINSTANCE, reasonForCall: DWORD,
    lpReserved: LPVOID): WINBOOL {.exportc, dynlib, stdcall.} =
  case reasonForCall:
    of DLL_PROCESS_ATTACH:
      NimMain()
      CreateThread(nil, nil, cast[LPTHREAD_START_ROUTINE](mainThread), cast[
          LPVOID](hModule), nil, nil)
    of DLL_PROCESS_DETACH:
      discard
    of DLL_THREAD_ATTACH:
      discard
    of DLL_THREAD_DETACH:
      discard
    else:
      discard
  return TRUE