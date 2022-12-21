import ./objects/GameObject
import ./manager/HudZoomManager
import ./manager/ChatHudManager
import ./patchables/Offsets
import strutils
import winim

type FloatingTextType* = enum
  Invulnerable
  Special
  Heal
  ManaHeal
  ManaDamage
  Dodge
  PhysicalDamageCritical
  MagicalDamageCritical
  TrueDamageCritical
  Experience
  Gold
  Level
  Disable
  QuestReceived
  QuestComplete
  Score
  PhysicalDamage
  MagicalDamage
  TrueDamage
  EnemyPhysicalDamage
  EnemyMagicalDamage
  EnemyTrueDamage
  EnemyPhysicalDamageCritical
  EnemyMagicalDamageCritical
  EnemyTrueDamageCritical
  Countdown
  OMW
  Absorbed
  Debug
  PracticeToolTotal
  PracticeToolLastHit
  PracticeToolDPS
  ScoreDarkStar
  ScoreProject0
  ScoreProject1
  ShieldBonusDamage

type
  cstringConstImpl {.importc:"const char*".} = cstring
  constChar* = distinct cstringConstImpl

type FloatingTextGetType = proc(floatingTextTypeInstance: ByteAddress, textType: FloatingTextType): cint {.gcsafe, thiscall.}
type FloatingTextAddInternalLine = proc(
  floatingTextInstance: ByteAddress, 
  target: ByteAddress, 
  textType: cint, 
  text: constChar,
  idk1: cfloat,
  idk2: cint,
  animationType: cint,
  instance2: DWORD
): void {.gcsafe, thiscall.}

type
  Game* = ref object
    address*: ByteAddress
    patch: cstring

    localPlayer: GameObject
    chatManager: ChatHudManager
    zoomManager: HudZoomManager

    floatingTextEnumInstance: ByteAddress
    floatingTextManagerInstance: ByteAddress

    hudInstance: ByteAddress
    zoomInstance: ByteAddress

    getFloatingTextType: FloatingTextGetType
    showFloatingTextFunction: FloatingTextAddInternalLine

proc init*(self: Game, baseAddress: ByteAddress): void =
  self.address = baseAddress

  self.patch = cast[cstring](self.address + Offsets.GameVersionOffset)
  self.localPlayer = cast[GameObject](self.address + Offsets.LocalPlayerInstanceOffset)

  self.hudInstance = cast[ByteAddress](self.address + Offsets.HudInstanceOffset)
  
  self.floatingTextEnumInstance = cast[ptr ByteAddress](self.address + 0x24FB358)[]
  self.floatingTextManagerInstance = cast[ptr ByteAddress](self.address + 0x24FB354)[]

  self.getFloatingTextType = cast[FloatingTextGetType](self.address + 0x5FBDD0)
  self.showFloatingTextFunction = cast[FloatingTextAddInternalLine](self.address + 0x5F1E50)

  self.chatManager = ChatHudManager()
  self.zoomManager = HudZoomManager()

  self.chatManager.init(self.address)
  self.zoomManager.init(self.address)

proc getPatchVersion*(self: Game): cstring =
  self.patch

proc getLocalPlayer*(self: Game): GameObject =
  self.localPlayer

proc getChatHudManager*(self: Game): ChatHudManager =
  self.chatManager

proc chatIsOpen*(self: Game): bool =
  self.chatManager.isOpen()

proc sendMessageChat*(self: Game, message: string): void =
  discard self.chatManager.sendMessage(message)

proc printMessageChat*(self: Game, message: string, format: int = 0): void =
  discard self.chatManager.printMessage(message, format)

proc getHudZoomManager*(self: Game): HudZoomManager =
  self.zoomManager

proc showFloatingText*(self: Game, text: cstring, textType: FloatingTextType, animationType: cint = 0): void = 
  let textTypePointer = self.getFloatingTextType(self.floatingTextEnumInstance, textType)
   
  self.showFloatingTextFunction(
      self.floatingTextManagerInstance, 
      cast[ptr ByteAddress](self.localPlayer)[],
      textTypePointer,
      constChar(text),
      0.0,
      0, 
      animationType,
      0
  )
  discard

var instance*: Game