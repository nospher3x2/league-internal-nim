import ./objects/GameObject
import ./manager/HudZoomManager
import ./manager/ChatHudManager
import ./manager/NetClientManager
import ./patchables/Offsets
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
  instance2: DWORD): void {.gcsafe, thiscall.}

type
  Game* = ref object
    address*: ByteAddress
    patch: cstring

    localPlayer: GameObject

    chatManager: ChatHudManager
    zoomManager: HudZoomManager
    netClientManager: NetClientManager

    floatingTextEnumInstance: ByteAddress
    floatingTextManagerInstance: ByteAddress

    hudInstance: ByteAddress

    getFloatingTextType: FloatingTextGetType
    showFloatingTextFunction: FloatingTextAddInternalLine

proc init*(self: Game, baseAddress: ByteAddress): void =
  self.address = baseAddress

  self.patch = cast[cstring](self.address + Offsets.GameVersionOffset)
  self.localPlayer = cast[GameObject](self.address + Offsets.LocalPlayerInstanceOffset)

  self.hudInstance = cast[ByteAddress](self.address + Offsets.HudInstanceOffset)
  self.floatingTextManagerInstance = cast[ptr ByteAddress](self.address + Offsets.FloatingTextManagerInstanceOffset)[]
  self.floatingTextEnumInstance = cast[ptr ByteAddress](self.address + (Offsets.FloatingTextManagerInstanceOffset+4))[]

  self.getFloatingTextType = cast[FloatingTextGetType](self.address + Offsets.FloatingTextGetTypeOffset)
  self.showFloatingTextFunction = cast[FloatingTextAddInternalLine](self.address + Offsets.FloatingTextAddInternalLineOffset)

  self.chatManager = ChatHudManager()
  self.zoomManager = HudZoomManager()
  self.netClientManager = NetClientManager()

  self.chatManager.init(self.address)
  self.zoomManager.init(self.address)
  self.netClientManager.init(self.address)

proc getPatchVersion*(self: Game): cstring =
  self.patch

proc getGameTime*(self: Game): cfloat = 
  cast[ptr cfloat](self.address + Offsets.GameTimeOffset)[]

proc getLocalPlayer*(self: Game): GameObject =
  self.localPlayer

proc getChatHudManager*(self: Game): ChatHudManager =
  self.chatManager

proc getHudZoomManager*(self: Game): HudZoomManager =
  self.zoomManager

proc getNetClientManager*(self: Game): NetClientManager =
  self.netClientManager

proc showFloatingText*(self: Game, target: GameObject, text: cstring, textType: FloatingTextType, animationType: cint = 0): void = 
  let textTypePointer = self.getFloatingTextType(self.floatingTextEnumInstance, textType)
   
  self.showFloatingTextFunction(
      self.floatingTextManagerInstance, 
      cast[ptr ByteAddress](target)[],
      textTypePointer,
      constChar(text),
      0.0,
      0, 
      animationType,
      0
  )
  discard

var instance*: Game