;;;;;;;;;; Loading ;;;;;;;;;;
    #SingleInstance, Force
    #Persistent
    #NoEnv
    ;#NoTrayIcon
    ;--------------------------------------------------
    #KeyHistory, 0
    ;#InstallKeybdHook
    ;#InstallMouseHook
    ;#UseHook
    ;--------------------------------------------------
    #MaxHotkeysPerInterval, 9999999
    #HotkeyInterval, 9999999
    ;--------------------------------------------------
    #MaxThreads, 255
    ;#MaxThreadsPerHotkey, 255
    ;--------------------------------------------------
    Process, Priority,, A
    CoordMode, ToolTip, Screen
    CoordMode, Pixel, Screen
    ListLines Off
    SendMode, Event ; Input
    SetBatchLines -1
    SetKeyDelay, -1, -1
    SetMouseDelay, -1, -1
    SetControlDelay -1
    SetWinDelay -1

;;;;;;;;;; Variables header ;;;;;;;;;;
    global gScreen       := [Round(A_ScreenWidth), Round(A_ScreenHeight)]
    global gScreenCenter := [Round(A_ScreenWidth / 2), Round(A_ScreenHeight / 2)] 
    global gFontScaling  := Round(A_ScreenHeight / 1080, 2)
    global gDPI          := (96 / A_ScreenDPI) 

;;;;;;;;;; Run as Administrator ;;;;;;;;;;
    ; https://www.autohotkey.com/docs/v1/lib/Run.htm#RunAs
    full_command_line := DllCall("GetCommandLine", "str")
    if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)")) {
        try { ; leads to having the script re-launching itself as administrator
            if A_IsCompiled
                Run *RunAs "%A_ScriptFullPath%" /restart
            else
                Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
        }
        ExitApp
    }
    full_command_line := ""

;;;;;;;;;; Include ;;;;;;;;;;
    SetWorkingDir %A_ScriptDir%\..\
    #include *i %A_Scriptdir%\AdvancedSettings.ahk
    ;--------------------------------------------------
    #include %A_Scriptdir%\CoreLibsFor_AHK\BaseLibs\WorkingWithFiles.ahk
    #include %A_Scriptdir%\CoreLibsFor_AHK\BaseLibs\TrayMenu.ahk
    #include %A_Scriptdir%\CoreLibsFor_AHK\BaseLibs\GuiInGame.ahk
    #include %A_Scriptdir%\CoreLibsFor_AHK\BaseLibs\ControlFunctions.ahk
    #include %A_Scriptdir%\CoreLibsFor_AHK\BaseLibs\TimeControl.ahk
    #include %A_Scriptdir%\CoreLibsFor_AHK\BaseLibs\CheckForUpdates.ahk
    #include %A_Scriptdir%\CoreLibsFor_AHK\BaseLibs\InputDevice.ahk
    ;--------------------------------------------------
    #include %A_Scriptdir%\CoreLibsFor_AHK\AuxiliaryScripts\FindText.ahk
    #include %A_Scriptdir%\CoreLibsFor_AHK\AuxiliaryScripts\Gdip.ahk
    
;;;;;;;;;; Start ;;;;;;;;;;
    Main()
Return

;;;;;;;;;; Scripts ;;;;;;;;;;
    Main() {
        global
            IniWrite, Autorun, % CheckingFiles("File", False, "SavedSettings.ini"), Installer, LaunchModifier
            Run, % """" ProgramSearch("AutoHotkey 1") """ """ A_ScriptDir "\Installer.ahk"""
        ExitApp
    }