#include once "fltk-c.bi"

dim as ubyte r8=128,g8=64,b8=0
dim as double rr=0.5,gg=0.26,bb=0.0
dim as zstring ptr file
dim as zstring ptr path

sub FileOrFolderCB cdecl (byval path as const zstring ptr)
  if path<>0 then print !"FileChosserCB(\"" & *path & !"\")"
end sub

flFileChooserCallback @FileOrFolderCB

flMessageTitleDefault("I'm a default Title !")
flAlert "I'm a alert message 1"

flMessageTitle("I'm a individual Title !")
flAlert "I'm a alert message 2"



print "flChoice() = " & flChoice("flChoice()", "button0", "button1", "button2")

flColorChooser "flColorChooser()",r8,g8,b8, FL_COLORCHOOSER_RGB
? "flColorChooser() = " & r8,g8,b8

flColorChooser2 "flColorChooser2()",rr,gg,gg, FL_COLORCHOOSER_RGB
? "flColorChooser2() = " & rr,gg,bb

? "flInput() = " & *flInput("flInput:","type here ...")


path = flDirChooser("select a folder", ExePath(), 1) ' 1 = relative 0 = absolute path
if path<>0 then ? "flDirChooser() = " & *path

flFileChooserOkLabel("I'm a OK label")
file = flFileChooser("select a file","*.bas", ExePath(), 1) ' 1 = relative 0 = absolute path
if file<>0 andalso len(*file) then ? "flFileChooser() = " & *file
sleep 3000

