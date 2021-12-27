@echo off
if -%1 == - goto NoParam

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
echo td.bat <EXE>
goto exit

:Ok
d:\tasm\bin\td %1
:exit
