{.passC: "-D__WINDOWS_MM__", passL: "-lstdc++ -lwinmm",
    compile: "vmt_smart_hook.h".}

{.pragma: vmthook.}

type 
  table_hook* {.bycopy, pure.} = ptr object of RootObj
    m_new_vmt: pointer
    m_old_vmt: pointer
    

    