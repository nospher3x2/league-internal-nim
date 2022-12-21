{.passL: "-s -static-libgcc".}
import winim/com
import strutils
import std/os
import ./game/objects/GameObject
import ./game/Game
import ./game/manager/HudZoomManager

proc mainThread(hModule: HINSTANCE) =

  # AllocConsole()
  # discard stdout.reopen("CONOUT$", fmWrite)

  # echo "oiii"

  let addressBase = GetModuleHandleA(nil)
  Game.instance = Game()
  Game.instance.init(addressBase)
  
  let game = Game.instance
  let zoomManager = game.getHudZoomManager()
  zoomManager.patchCheatDetection()
  zoomManager.changeMaxValue(2250.0)  
  game.showFloatingText("CarryNim loaded", FloatingTextType.ScoreDarkStar, 0)

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