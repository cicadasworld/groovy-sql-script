@echo off

REM
REM ================================================================
REM 创建快捷方式
REM ================================================================
REM
:CreateShorcut

set linkfile=%~dp0%~n0.lnk
IF EXIST "%linkfile%" goto SetDevEnv

set temp_js_file=%TEMP%\%~n0.js
SET _K_LinkFile=%linkfile%
SET _K_TargetPath=%comspec%
SET _K_Arguments=/k ""%~f0""
SET _K_Description=%~n0
SET _K_WorkDir=%~dp0

if exist "%temp_js_file%" del /f "%temp_js_file%"
echo var oWS = new ActiveXObject("WScript.Shell"); >> "%temp_js_file%"
echo var oEnv = oWS.Environment("Process");        >> "%temp_js_file%"
echo var linkfile = oEnv("_K_LinkFile");           >> "%temp_js_file%"
echo var oLink = oWS.CreateShortcut(linkfile);     >> "%temp_js_file%"
echo oLink.TargetPath = oEnv("_K_TargetPath");     >> "%temp_js_file%"
echo oLink.Arguments = oEnv("_K_Arguments");       >> "%temp_js_file%"
echo oLink.Description = oEnv("_K_Description");   >> "%temp_js_file%"
echo oLink.WindowStyle = 1;                        >> "%temp_js_file%"
echo oLink.WorkingDirectory = oEnv("_K_WorkDir");  >> "%temp_js_file%"
echo oLink.Save();                                 >> "%temp_js_file%"
cscript "%temp_js_file%"
del /f "%temp_js_file%"

set temp_js_file=
SET _K_LinkFile=
SET _K_TargetPath=
SET _K_Arguments=
SET _K_Description=
SET _K_WorkDir=

echo 请使用快捷方式 "%linkfile%" 来启动命令行工具
set linkfile=
pause
exit /b 0


REM
REM ================================================================
REM 设置环境变量
REM ================================================================
REM
:SetDevEnv

set JAVA_HOME=jre1.8.0_251
set GROOVY_HOME=groovy-3.0.5
set PATH=%PATH%;%JAVA_HOME%\bin;%GROOVY_HOME%\bin;

:Done