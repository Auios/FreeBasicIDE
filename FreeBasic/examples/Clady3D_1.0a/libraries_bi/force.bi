#inclib "DI8FF"

Declare sub initforce STDCALL Alias "_input_initforce" ()
Declare sub setjoy STDCALL Alias "_input_setjoy" (byval id as uinteger)
Declare sub runeff STDCALL Alias "_input_runeff" (byval nume as string)
Declare sub loadeff STDCALL Alias "_input_loadeff" (byval nume as string)
Declare sub runloadedeff STDCALL Alias "_input_runloadedeff" ()
Declare sub stopforce STDCALL Alias "_input_stopforce" ()
Declare sub releaseforce STDCALL Alias "_input_releaseforce" ()