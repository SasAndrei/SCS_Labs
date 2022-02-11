@echo off
set xv_path=C:\\Xilinx2\\Vivado\\2014.4\\bin
echo "xvhdl -m32 -prj phaseGenerator_vhdl.prj"
call %xv_path%/xvhdl  -m32 -prj phaseGenerator_vhdl.prj -log compile.log
if "%errorlevel%"=="1" goto END
if "%errorlevel%"=="0" goto SUCCESS
:END
exit 1
:SUCCESS
exit 0
