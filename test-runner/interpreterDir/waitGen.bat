@echo off
type %1
echo generator trace > gentrace.txt
set consoleInput=abc
echo console input:
echo %consoleInput%
PING 1.1.1.1 -n 1 -w 60000 >NUL
