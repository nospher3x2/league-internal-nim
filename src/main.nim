{.passL: "-s -static-libgcc".}
import winim/com
import std/strformat
import ./game/objects/GameObject
import ./game/Game

proc mainThread(hModule: HINSTANCE) =

  AllocConsole()
  discard stdout.reopen("CONOUT$", fmWrite)

  echo "oiii"

  let addressBase = GetModuleHandleA(nil)
  Game.instance = Game()
  Game.instance.init(addressBase)
  
  let game = Game.instance
  let localPlayer = game.getLocalPlayer()
  discard game.sendChat(fmt"minha vida: {localPlayer.getHealth()}/{localPlayer.getMaxHealth()}")
  discard game.printChat(fmt"Game Version: {game.getVersion()}. Time: {game.getTime()}", 0x3)

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