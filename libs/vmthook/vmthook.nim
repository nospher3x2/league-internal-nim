{.passC: "-D__WINDOWS_MM__", passC: "-s -static-libgcc" passL: "-std=c++11", passL: "-lstdc++ -lwinmm",
    compile: "vmt_smart_hook.h".}

{.pragma: vmthook,
  cdecl,
  importc,
  discardable
.}

type 
  table_hook* {.bycopy, pure.} = ptr object of RootObj
    m_new_vmt: pointer
    m_old_vmt: pointer
  vmt_smart_hook* {.bycopy, pure.} = ptr object of table_hook
    m_class: pointer

proc apply_hook*[T](hook: vmt_smart_hook, index: csize_t): void {.vmthook.}
proc create_smart_hook(class_base: pointer): vmt_smart_hook {.vmthook.}

proc initVMTHook*(class_base: pointer): vmt_smart_hook =
  create_smart_hook(class_base)