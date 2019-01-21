@echo off
SET THEFILE=d:\pascal\tugas_besar\tugas_besar.exe
echo Linking %THEFILE%
c:\dev-pas\bin\ldw.exe  D:\Pascal\Tugas_Besar\rsrc.o -s   -b base.$$$ -o d:\pascal\tugas_besar\tugas_besar.exe link.res
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
