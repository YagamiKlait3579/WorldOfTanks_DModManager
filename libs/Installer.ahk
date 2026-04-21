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
    ;--------------------------------------------------
    #include *i %A_Scriptdir%\AdditionalFunctions.ahk
    ;--------------------------------------------------
    OnExit("BeforeExiting_Installer")

;;;;;;;;;; Variables ;;;;;;;;;;
    SaC_DLL := CheckingFiles("File", False, "WorldOfTanks_Images.dll")
    global ConfigEditorErrors := ""
    global CB2
    ;--------------------------------------------------
    SettingsUploading()
    CheckVersion()

;;;;;;;;;; Gui ;;;;;;;;;;
    PlaceForTheText := "Text text text text text text text text text text text text"
    ;--------------------------------------------------
    UpdateDGP({"Transparency" : 100, "Blur" : 255, "FontSize" : 25, "BorderColor" : "ff5100", "BorderSize" : 2})
    GuiInGame("Start", "Installer")
    Gui, Installer: Add, Text, xm ym +Center cYellow vT1, %PlaceForTheText%
    GuiControl, Installer: Text, T1, World of Tanks : DMod manager
    Gui, Installer: Add, Text, xm y+m +Center vStatusGUI, %PlaceForTheText%
    GuiControl, Installer: Text, StatusGUI,
    GuiInGame("End", "Installer", {"pos" : ["center", (A_ScreenHeight / 7)]})

;;;;;;;;;; Start ;;;;;;;;;;
    Installer(LaunchModifier)
    #include %A_Scriptdir%\ConfigEditor.ahk
    if ((ConfigEditorErrors != "" && ConfigEditorErrors != "Ошибки при изменении конфигурационных файлов:") && copyErrorReport)
        MsgBox, 48, World of Tanks : DMod manager, %ConfigEditorErrors%
ExitApp


;;;;;;;;;; Installer ;;;;;;;;;;
    Installer(param = "Menu") {
        global
        local A_Loop, A_key, B_Loop, B_key, C_Loop, C_key
        local x1, y1, x2, y2, x3, y3
        local aPid := [], installerFile := [], coords := []
        local ErrorList := "Не удалось найти следующие моды:"
        installerFile[1] := A_WorkingDir . "\libs\Downloads\D Mod "  . vDModInServer . ".exe"
        installerFile[2] := A_WorkingDir . "\libs\Downloads\D Mod Texture " . vDModTextureInServer . ".exe"
        aPid[1] := "D Mod " vDModInServer . ".tmp"
        aPid[2] := "D Mod Texture " vDModTextureInServer . ".tmp"
        for A_Loop, A_key in installerFile
            if !FileExist(A_key) && settingTreeMain[A_Loop] {
                MsgBox, 16, World of Tanks : DMod manager, Установочный файл не найден! `nУстановка будет отменена.
                ExitApp
            }
        if (vDModInServer = vDModInGame) {
            if (param = "Menu") {
                MsgBox, 36, World of Tanks : DMod manager, Новых версий не найдено.`nПереустановить моды?
                IfMsgBox, No
                    ExitApp
            } Else
                ExitApp
        }
        ; Установка модов
        local procedureOfActions := [["OK", "Misic", "Next", "Accept", "Next", "Next", "Next"]
                                    ,["OK", "Misic", "Next", "Next"]
                                    ,["Next", "Install", "Next", "Info", "Complete"]
                                    ,["Next", "Install", "Info2", "Complete"]]
        for A_Loop, A_key in settingTreeMain {
            if A_key {
                x1 := "", y1 := "", x2 := "", y2 := "", x3 := "", y3 := ""
                GuiInGame("Edit", "Installer", {"id" : "StatusGUI", "Text" : "Установка " (A_Loop = 1 ? "D Mod" : "D Mod Texture")})
                Run, % """" installerFile[A_Loop] """"
                WinWait, % "ahk_exe " aPid[A_Loop]
                WinSet, AlwaysOnTop, 0, % "ahk_exe " aPid[A_Loop]
                WinSet, AlwaysOnTop, 1, % "ahk_exe " aPid[A_Loop]
                WinGetPos, x1, y1, x2, y2, % "ahk_exe " aPid[A_Loop]
                for B_Loop, B_key in procedureOfActions[A_Loop] {
                    if (B_Loop = 2) {
                        x3 := x2, y3 := y2
                        Loop, {
                            lSleep(100)
                            WinGetPos, x1, y1, x2, y2, % "ahk_exe " aPid[A_Loop]
                        } Until (((x3 != x2) && (y3 != y2)) && x2 && y2)
                    }
                    if !SearchAndClick(B_key, "Wait", SaC_timeout, [x1, y1, x1+x2, y1+y2]) {
                        MsgBox, 16, World of Tanks : DMod manager, Ошибка установщика! `nУстановка модов будет отменена.
                        Process, Close, % "ahk_exe " aPid[A_Loop]
                        ExitApp
                    }
                }
                lSleep(SaC_timeout * 10) ; Для слабого компа Никиша?
                for B_Loop, B_key in settingTreeHeadlines[A_Loop] {
                    if (B_key && !soloFlag[A_Loop, B_Loop]) {
                        if !SearchAndClick(A_Loop "-" B_Loop "-MAIN", "scrolling", SaC_scroll, [x1, y1, x1+x2, y1+y2])
                            ErrorList .= "`n" textTreeHeadlines[A_Loop, B_Loop] " (вся ветка)"
                    } else {
                        for C_Loop, C_key in settingTreeList[A_Loop, B_Loop]
                            if C_key
                                if !SearchAndClick(A_Loop "-" B_Loop "-" C_Loop, "scrolling", SaC_scroll, [x1, y1, x1+x2, y1+y2])
                                    ErrorList .= "`n" textTreeList[A_Loop, B_Loop, C_Loop]
                    }
                }
                for B_Loop, B_key in procedureOfActions[A_Loop + 2]
                    if !SearchAndClick(B_key, "Wait", SaC_timeout * 3, [x1, y1, x1+x2, y1+y2]) {
                        MsgBox, 16, World of Tanks : DMod manager, Ошибка установщика! `nУстановка модов будет отменена.
                        Process, Close, % "ahk_exe " aPid[A_Loop]
                        ExitApp
                    }
            }
        }
        if (ErrorList != "Не удалось найти следующие моды:")
            MsgBox, 16, World of Tanks : DMod manager, %ErrorList%
        ; Установка дополнительных модов
        if (CB1 && (GameFolder != " Не указана")) {
            GuiInGame("Edit", "Installer", {"id" : "StatusGUI", "Text" : "Копирование дополнительных модов"})
            if !FileExist(A_WorkingDir "\Additional mods\mods") {
                MsgBox, 16, World of Tanks : DMod manager, Не удалось найти папку mods с дополнительными модами.`nУстановка дополнительных модов будет отменена!
                ExitApp
            }
            if !FileExist(A_WorkingDir "\Additional mods\res_mods") {
                MsgBox, 16, World of Tanks : DMod manager, Не удалось найти папку res mods с дополнительными модами.`nУстановка дополнительных модов будет отменена!
                ExitApp
            }
            CopyAllMods(A_WorkingDir "\Additional mods\mods", GameFolder "\mods") 
            CopyAllMods(A_WorkingDir "\Additional mods\res_mods", GameFolder "\res_mods") 
        } 
    }

;;;;;;;;;; Functions ;;;;;;;;;;
    fMouseClick(x, y, t = 25) {
        fSetCursor(x, y)
        lSleep(t)
        fMouseInput("Left")
    }

    SearchAndClick(nameKey, param, value, coords) {
        /*
            param = Wait
                value = время ожидания ключа (сек.)
            param = scrolling или scroll
                value = колличество прокрутов до ошибки
         */
        global
        local aX, aY, imageSize, A_Stamp 
        fSetCursor(gScreenCenter[1], gScreenCenter[2])
        lSleep(25)
        TimeStamp(A_Stamp)
        Loop, {
            ImageSearch, aX, aY, coords[1], coords[2], coords[3], coords[4], % " *" SaC_shades " HBITMAP:" ReadImages(SaC_DLL, nameKey)
            if !ErrorLevel {
                imageSize := GetImageSizeFromDll(SaC_DLL, nameKey)
                fMouseClick(aX + (imageSize.width / 2), aY + (imageSize.height / 2))
                lSleep(25)
                Return true
            }
            switch param {
                case "wait" : {
                    if (TimePassed(A_Stamp,, "sec") > value)
                        Return False
                    lSleep(100)
                }
                case "scrolling", "scroll" : {
                    if (A_Index > value) {
                        Loop, %value% 
                            fMouseInput("WheelUp", 1), lSleep(25)                        
                        Return False
                    }
                    fMouseInput("WheelDown", 1)
                    lSleep(25)
                }
            }
        }
    }

;;;;;;;;;; Config editor ;;;;;;;;;;
    fConfigEditor(FilePath, param*) {
        if !CB2
            Return false

        ; Инициализируем список ошибок при первом вызове
        if (ConfigEditorErrors = "")
            ConfigEditorErrors := "Ошибки при изменении конфигурационных файлов:"

        localErrors := false
        fileErrorMessages := ""  ; Для сбора ошибок по текущему файлу

        ; Проверяем четное количество параметров (должны быть пары)
        if (param.Length() & 1) {  ; Проверка на нечетность
            ConfigEditorErrors .= "`n`n- Файл: " FilePath " - Нечетное количество параметров (должны быть пары ''найти-заменить'')"
            localErrors := true
        }

        ; Проверяем существование файла
        if !FileExist(FilePath) {
            ConfigEditorErrors .= "`n`n- Файл не найден: " FilePath
            localErrors := true
        }

        ; Если есть критические ошибки (нечетное количество параметров или файл не существует), 
        ; дальше не продолжаем для этого файла
        if localErrors
            return false

        ; Читаем содержимое файла
        FileRead, FileContent, %FilePath%
        if ErrorLevel {
            ConfigEditorErrors .= "`n`n- Ошибка чтения файла: " FilePath
            return false
        }

        NewContent := FileContent
        fileChanged := false
        missingTexts := []  ; Массив для хранения ненайденных текстов

        ; Обрабатываем все пары "найти-заменить"
        Loop, % param.Length() // 2 {
            Index := (A_Index - 1) * 2 + 1
            SearchText := param[Index]
            ReplaceText := param[Index + 1]

            ; Проверяем, существует ли искомая строка
            if !InStr(NewContent, SearchText) {
                missingTexts.Push(SearchText)  ; Добавляем в массив ненайденных
                continue  ; Продолжаем с остальными заменами для этого файла
            }

            ; Заменяем только первое вхождение
            Pos := InStr(NewContent, SearchText)
            if (Pos > 0) {
                Before := SubStr(NewContent, 1, Pos - 1)
                After := SubStr(NewContent, Pos + StrLen(SearchText))
                NewContent := Before . ReplaceText . After
                fileChanged := true
            }
        }

        ; Если были ненайденные тексты, добавляем их одной группой
        if (missingTexts.Length() > 0) {
            ConfigEditorErrors .= "`n`n- Файл: " FilePath "`n  Текст для замены не найден:"
            for index, text in missingTexts {
                ConfigEditorErrors .= "`n    """ text """"
            }
        }

        ; Если ничего не изменилось и не было ошибок
        if (!fileChanged && missingTexts.Length() = 0) {
            ; Это не ошибка, просто ничего не нужно менять
            return false
        }

        ; Если были изменения, записываем файл
        if fileChanged {
            ; Создаем резервную копию (опционально, можно убрать)
            if FileExist(FilePath) {
                FileCopy, %FilePath%, %FilePath%.backup, 1
            }

            FileDelete, %FilePath%
            FileAppend, %NewContent%, %FilePath%
            if ErrorLevel {
                ConfigEditorErrors .= "`n- Ошибка записи файла: " FilePath
                return false
            }
        }

        ; Успешно завершено
        return true
    }

;;;;;;;;;; Additional mods ;;;;;;;;;;
    CopyAllMods(SourceFolder, DestFolder) {
        ; Создаем папку назначения если не существует
        if !FileExist(DestFolder)
            FileCreateDir, %DestFolder%
        
        ErrorCount := 0
        SuccessCount := 0
        
        ; Копируем все файлы из корня с заменой
        Loop, Files, % SourceFolder . "\*.*", F
        {
            try {
                FileCopy, %A_LoopFileFullPath%, %DestFolder%\, 1
                if ErrorLevel
                    ErrorCount++
                else
                    SuccessCount++
            }
            catch {
                ErrorCount++
            }
        }
        
        ; Копируем все папки рекурсивно с заменой файлов
        Loop, Files, % SourceFolder . "\*", D
        {
            try {
                ; Копируем содержимое папки, а не саму папку
                CopyFolderContents(A_LoopFileFullPath, DestFolder . "\" . A_LoopFileName)
                SuccessCount++
            }
            catch {
                ErrorCount++
            }
        }
        
        if (ErrorCount > 0) {
            MsgBox, 48, World of Tanks : DMod manager, % "Копирование дополнительных модов завершено с ошибками!`n"
                    . "Успешно: " SuccessCount "`n"
                    . "Ошибок: " ErrorCount
            return false
        }
        return true
    }

    CopyFolderContents(SourceFolder, DestFolder) {
        ; Создаем папку назначения если не существует
        if !FileExist(DestFolder)
            FileCreateDir, %DestFolder%
        
        ; Копируем файлы из корневой папки
        Loop, Files, % SourceFolder . "\*.*", F
        {
            FileCopy, %A_LoopFileFullPath%, %DestFolder%\, 1
        }
        
        ; Рекурсивно копируем подпапки
        Loop, Files, % SourceFolder . "\*", D
        {
            ; Получаем имя подпапки
            SplitPath, A_LoopFileFullPath, , , , OutNameNoExt
            NewDestFolder := DestFolder . "\" . OutNameNoExt
            
            ; Рекурсивно копируем содержимое подпапки
            CopyFolderContents(A_LoopFileFullPath, NewDestFolder)
        }
    }

;;;;;;;;;; Exit ;;;;;;;;;;
    BeforeExiting_Installer() {
        global
        IniWrite, Menu, % CheckingFiles("File", False, "SavedSettings.ini"), Installer, LaunchModifier
    }