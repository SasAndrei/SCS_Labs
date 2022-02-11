@echo off
set xv_path=C:\\Xilinx2\\Vivado\\2014.4\\bin
call %xv_path%/xelab  -wto 85cf275e8c944bd8b9bf8c8bd6896f6f -m32 --debug typical --relax -L xil_defaultlib -L secureip --snapshot phaseGenerator_behav xil_defaultlib.phaseGenerator -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
