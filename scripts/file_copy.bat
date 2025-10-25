@echo off
REM -----------------------------------
REM Network File/Directory Move Script
REM Supports recursive directories
REM -----------------------------------

REM ======== CONFIGURATION =========
SET NETWORK_SHARE=\\192.168.1.100\sharedfolder
SET NETWORK_USER=YourUsername
SET NETWORK_PASS=YourPassword
REM ================================

REM ======== USER INPUT ============
SET /P SRC="Enter source file or directory path (local): "
SET /P DST="Enter destination path (remote relative to share): "
REM ================================

REM ======== MAP NETWORK DRIVE =====
NET USE Z: %NETWORK_SHARE% /USER:%NETWORK_USER% %NETWORK_PASS%
IF ERRORLEVEL 1 (
    ECHO Failed to connect to network share.
    GOTO END
)

REM ======== CREATE DESTINATION =====
IF NOT EXIST "Z:\%DST%" (
    MKDIR "Z:\%DST%"
)

REM ======== MOVE FILE/DIRECTORY =====
ROBOCOPY "%SRC%" "Z:\%DST%" /MOVE /E /Z /R:3 /W:5
REM /MOVE -> Moves files and directories
REM /E -> Includes all subdirectories (even empty)
REM /Z -> Restartable mode
REM /R:3 -> Retry 3 times on failure
REM /W:5 -> Wait 5 seconds between retries

REM ======== UNMAP NETWORK DRIVE =====
NET USE Z: /DELETE

:END
ECHO Transfer complete.
PAUSE
