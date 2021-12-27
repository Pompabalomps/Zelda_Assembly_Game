@echo off
if -%1 == - goto NoParam
if -%2 == - goto NoParam

if not exist %1 goto NotExist

goto Ok

:NotExist
echo ERROR!!!
type %1
echo Not Exist!!!
goto exit

:NoParam
echo ERROR!!!
echo Variant of a call:
echo builtEXE.bat Rewri.asm Rewri.exe
goto exit

:Ok
d:\tasm\bin\tasm %1 temp.obj /la /zi
if exist %2 del %2
d:\tasm\bin\tlink /v/x temp.obj
ren Temp.exe %2 
if exist *.obj del *.obj >nul
if exist *.map del *.map >nul
:exit
