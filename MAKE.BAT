@echo off

set include=e:\dev\bc\include
set lib=e:\dev\bc\lib

del *.obj
del *.dat
del *.exe

bcc -P -mt -L%lib% -I%include% save.c
bcc -P -mt -S -p bootall.c
bcc -P -mt -S -p tools.c
bcc -P -mt -S -p copy.c
tasm bootall
tasm tools
tasm copy
tasm start
tasm mbr

tlink /C /t START.OBJ BOOTALL.OBJ TOOLS.OBJ COPY.OBJ
tlink /C /t MBR.OBJ

ren mbr.com mbr.dat
ren start.com bootall.dat

save

bcc -P -I%include% -L%lib% -ms config.c CWINDOW.LIB
