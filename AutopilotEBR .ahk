;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\CoreLibsFor_AHK\BaseLibs\Header.ahk
    ;--------------------------------------------------
    #IfWinActive, Мир танков 
    global PWN := "Мир танков" ; Program window name
    ;CheckForUpdates("YagamiKlait3579",, "main", CheckingFiles("File", False, "Header.ahk"))
    OnExit("BeforeExiting_EBR")

;;;;;;;;;; Setting ;;;;;;;;;;
    StartKey        = SC0x29
    ModKey          = x
    CC_KeyAdd       = r
    CC_KeySubtract  = f
    SettingFPS     := 144
    EBR_shades     := 100    ; % отклонения ImageSearch
    ;--------------------------------------------------
    GuiPositionX     := 0.1250    ; Изменение положения интерфейса по горизнтали (X-координата) только для этого скрипта
    GuiPositionY     := 0.9775    ; Изменение положения интерфейса по вертикали (Y-координата) только для этого скрипта

;;;;;;;;;; Variables ;;;;;;;;;;
    EBR_DLL := CheckingFiles("File", False, "AutopilotEBR_Images.dll")
    imagePath_Mod   := [CreateImage(EBR_DLL, "EBR_Off"), CreateImage(EBR_DLL, "EBR_On")]
    imagePath_Speed := [CreateImage(EBR_DLL, "Speed3"), CreateImage(EBR_DLL, "Speed2"), CreateImage(EBR_DLL, "Speed1")
                      , CreateImage(EBR_DLL, "Speed0"), CreateImage(EBR_DLL, "Speed0-1"), CreateImage(EBR_DLL, "Speed-2")]
    panelCoords := [1, (A_ScreenHeight/4)*3, A_ScreenWidth/8, A_ScreenHeight - 1]
    ;--------------------------------------------------
    A_ScriptStatus := False

;;;;;;;;;; Hotkeys ;;;;;;;;;;
    Hotkey, *%StartKey%, Main

;;;;;;;;;; Gui ;;;;;;;;;;
    PlaceForTheText := " Ширина самого длинного текста "
    ;--------------------------------------------------
    UpdateDGP({"Transparency" : gTransparency, "Blur" : gBlur, "Scale" : gInterfaceScale})
    GuiInGame("Start", "MainInterface")
        Gui, MainInterface: Add, Text, xm ym +Center, % SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1)
        Gui, MainInterface: Add, Text, x+m +Center +border cRed vT1, ` Disabled `
    GuiInGame("End", "MainInterface", {"ratio" : [GuiPositionX,GuiPositionY]})
    fSuspendGui("On", "MainInterface")
Return

;;;;;;;;;; Scripts ;;;;;;;;;;
    Main() {
        global  
        if !A_ScriptStatus {
            A_ScriptStatus := !A_ScriptStatus
            GuiInGame("Edit", "MainInterface", {"id" : "T1", "Color" : "Lime", "Text" : "Enabled"})
            SetTimer, Autopilot, 1
        } else
            Reload
    }

    Autopilot() {
        global
        local KeyStatus, notDeath
        KeyStatus := KeyChecking()
        switch KeyStatus {
            case 1 :
                if !IndicatorChecking(panelCoords, imagePath_Mod[2], EBR_shades)
                    Send, {Blind}{%ModKey%}
            case 2 :
                if !IndicatorChecking(panelCoords, imagePath_Mod[1], EBR_shades)
                    Send, {Blind}{%ModKey%}
            Default: {
                for A_Loop, A_key in imagePath_Mod 
                    if IndicatorChecking(panelCoords, A_key, EBR_shades, 3) {
                        notDeath := True
                }
                if !notDeath
                    Reload
            }   
        }
    }

;;;;;;;;;; Functions ;;;;;;;;;;
    IndicatorChecking(coords, imagePath, shades, attempts = 5) {
        Loop, %attempts% {
            ImageSearch, x1, y1, coords[1], coords[2], coords[3], coords[4], % " *" shades " " imagePath
            if !ErrorLevel
                Return true
            fSleep(1)
        }
        Return False
    } 

    KeyChecking() {
        if (GetKeyState("w", "p") || GetKeyState("s", "p")) 
            Return 1
        if (GetKeyState("a", "p") || GetKeyState("d", "p"))
            Return 2
        Return 0
    }

    CreateImage(DllPath, ResourceName, ResourceType = "PNG") {
        hModule := DllCall("LoadLibraryEx", "Str", DllPath, "UInt", 0, "UInt", 2)
        hRes := DllCall("FindResource", "Ptr", hModule, ((ResourceName ~= "^\d+$") ? "UInt" : "Str"), ResourceName, "Str", ResourceType)
        hResData := DllCall("LoadResource", "Ptr", hModule, "Ptr", hRes)
        pResData := DllCall("LockResource", "Ptr", hResData)
        ResSize := DllCall("SizeofResource", "Ptr", hModule, "Ptr", hRes)

        TempImagePath := A_Temp "\TempImage_" ResourceName ".png"
        FileDelete, %TempImagePath%
        hFile := DllCall("CreateFile", "Str", TempImagePath, "UInt", 0x40000000, "UInt", 0, "UInt", 0, "UInt", 2, "UInt", 0, "UInt", 0, "Ptr")
        DllCall("WriteFile", "Ptr", hFile, "Ptr", pResData, "UInt", ResSize, "UInt*", BytesWritten, "UInt", 0)
        DllCall("CloseHandle", "Ptr", hFile)

        DllCall("FreeLibrary", "Ptr", hModule)
        return TempImagePath
    }

;;;;;;;;;; Exit ;;;;;;;;;;
    BeforeExiting_EBR() {
        global
        for A_Loop, A_Key in imagePath_Mod
            FileDelete, %A_Key%
        for A_Loop, A_Key in imagePath_Speed
            FileDelete, %A_Key%
    }