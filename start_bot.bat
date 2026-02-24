@echo off
chcp 65001 >nul
title Antigravity Auto Press Run

:LOOP
echo =========================================
echo    Antigravity Auto Press Run Script
echo =========================================
echo.
echo 起動中...
node antigravity_auto_press_run.js
echo.
echo [WARN] プロセスが予期せず終了しました。5秒後に再起動します...
timeout /t 5 /nobreak >nul
goto LOOP
