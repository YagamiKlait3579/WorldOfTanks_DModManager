;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\CoreLibsFor_AHK\BaseLibs\Header.ahk
    OnExit("BeforeExiting_Menu")

;;;;;;;;;; Variables ;;;;;;;;;;
    idTreeMain := [], idTreeHeadlines := [], idTreeList := []
    global UserDownloadFolder
    CB3 := ManageStartup(A_WorkingDir "\libs\Autorun.ahk", "check", "DModManager_")
    ;--------------------------------------------------
    SettingsUploading()
    CheckVersion()
    
;;;;;;;;;; Gui ;;;;;;;;;;
    ;*** GUI Variables ***
        GUI_Text1 := "E6F1FF"   ; Цвет TreeView
        GUI_Text2 := "19e1ff"   ; Основной текст
        GUI_Text3 := "ff0000"   ; Вторичный текст
        GUI_Text4 := "e1e119"   ; Кнопки
        GUI_Background := "1e1e1e"
        GUI_Background2 := "0f0f0f" ;0f0f0f

    ;*** Head ***
        UpdateDGP({"FontSize" : 12})
        GUI_MenuParam := UpdateDGP("Save")
        Gui, ModManager_Menu: New, +LastFound -DPIScale +Border -MinimizeBox +HwndModManager_Menu
        Gui, ModManager_Menu: Color, %GUI_Background%
        Gui, ModManager_Menu: Margin, % GUI_MenuParam.Margin.1, % GUI_MenuParam.Margin.2
        Gui, ModManager_Menu: Font, % " s"GUI_MenuParam.FontSize " q3", % GUI_MenuParam.Font    
        Gui, ModManager_Menu: Show, % " w"(A_ScreenWidth/2) " h"(A_ScreenWidth/2/16*9), World of Tanks : DMod manager
        WinGetPos, MM_X, MM_Y, MM_W, MM_H, ahk_id %ModManager_Menu%
    ;*** Info ***
        Gui, ModManager_Menu: Add, Text, % " x"MM_W*0.01 " y"MM_H*0.025 " w"MM_W*0.3 " c"GUI_Text2 " +Section +Right +HwndhText1" ,Последняя версия DMod: `
        Gui, ModManager_Menu: Add, Text, % " x+ yp w"MM_W*0.125 " c"GUI_Text3 " +Left +HwndhText2",` %vDModInServer%
        T1_H := GuiLineWidth(hText1)
        T2_H := GuiLineWidth(hText2)
        ;--------------------------------------------------
        Gui, ModManager_Menu: Add, Text, % " xs y+m w"T1_H " +Right c"GUI_Text2, Версия DMod в игре: `
        Gui, ModManager_Menu: Add, Text, % " x+ yp w"T2_H " +Left vvText2 c"GUI_Text3,` %vDModInGame%
        Gui, ModManager_Menu: Add, Text, % " xs y+ w"T1_H " +Right c"GUI_Text2, Версия игры: `
        Gui, ModManager_Menu: Add, Text, % " x+ yp w"T2_H " +Left vvText1 c"GUI_Text3,` %vGame%

        ;--------------------------------------------------
        Gui, ModManager_Menu: Add, Text, % " xs y+m w"T1_H " +Section +Right c"GUI_Text2, Папка с игрой:
        Gui, ModManager_Menu: Add, Text, % " x+ ys w"T2_H " +Center c"GUI_Text4 " gGUI_Handler vRGF1", 🛠️ Обзор
        Gui, ModManager_Menu: Add, Text, % " xs y+ w"T1_H+T2_H " +Left c"GUI_Text3 " +Border vRGF2",` %GameFolder%
        ;--------------------------------------------------
        Gui, ModManager_Menu: Add, Text, xs y+m +HwndhCB3,`   `n   `
        Gui, ModManager_Menu: Add, Checkbox, % " x+ yp +HwndhCB3_2 gGUI_Handler vCB3 -Tabstop Checked" CB3,`   `n   `
        Gui, ModManager_Menu: Add, Text, % " x+ yp w"(T1_H + T2_H - GuiLineWidth(hCB3, hCB3_2)) " +Left c"GUI_Text2
        , Запускать проверку и установку модов при старте системы?
        ;--------------------------------------------------
        Gui, ModManager_Menu: Add, Text, xs y+ +HwndhCB1,`   
        Gui, ModManager_Menu: Add, Checkbox, % " x+ yp +HwndhCB1_2 gGUI_Handler vCB1 -Tabstop Checked" CB1,`
        Gui, ModManager_Menu: Add, Text, % " x+ yp w"(T1_H + T2_H - GuiLineWidth(hCB1, hCB1_2)) " +Left c"GUI_Text2
        , Ставить дополнительные моды?
        ;--------------------------------------------------
        Gui, ModManager_Menu: Add, Text, xs y+ +HwndhCB2,`   
        Gui, ModManager_Menu: Add, Checkbox, % " x+ yp +HwndhCB2_2 gGUI_Handler vCB2 -Tabstop Checked" CB2,`
        Gui, ModManager_Menu: Add, Text, % " x+ yp w"(T1_H - GuiLineWidth(hCB2, hCB2_2)) " +Left c"GUI_Text2
        , Редактировать конфиги?
        Gui, ModManager_Menu: Add, Text, % " x+ yp w"T2_H " +Center c"GUI_Text4 " gGUI_Handler vConfigSettings", 🛠️ Настроить
        ;--------------------------------------------------
        Gui, ModManager_Menu: Add, Text, % " x"MM_W*0.825 " y"MM_H*0.025 " w"MM_W*0.15 " c"GUI_Text4 " +Center +Border +Section vButton1 gGUI_Handler +HwndhButton1" , Start
        B1_H := GuiLineWidth(hButton1)
        Gui, ModManager_Menu: Add, Text, % " xp y+m w"B1_H " c"GUI_Text4 " +Center +Border gGUI_Handler vButton2" , 💾 D Mod 
        Gui, ModManager_Menu: Add, Text, % " xp y+ w"B1_H " c"GUI_Text4 " +Center +Border gGUI_Handler vButton3" , 💾 Texture 
    ;*** Links ***
        Gui, ModManager_Menu: Add, Picture, % " xp y"MM_H*0.75 " w"B1_H " h-1 +Border +BackgroundTrans vDiscordGUI", % "HBITMAP:" ReadImages(CheckingFiles("File", False, "Base_Images.dll"), "DiscordLogo")
        funcObj := Func("Tray_links").Bind("Discord")
        GuiControl ModManager_Menu: +g, DiscordGUI, %funcObj%
        ;--------------------------------------------------
        Gui, ModManager_Menu: Add, Picture, % "xp y+m w"B1_H " h-1 +Border +BackgroundTrans vGitHubGUI", % "HBITMAP:" ReadImages(CheckingFiles("File", False, "Base_Images.dll"), "GitHubLogo")
        funcObj := Func("Tray_links").Bind("GitHub")
        GuiControl ModManager_Menu: +g, GitHubGUI, %funcObj%
    ;*** End ***  
        Gui, ModManager_Menu: Add, Picture, % "x0 y0 w" (A_ScreenWidth/2) " h-1", % "HBITMAP:" ReadImages(CheckingFiles("File", False, "WorldOfTanks_Images.dll"), "WoT_BG_" SafeRandom(1,5))
    ;*** List ***
        Gui, ModManager_Menu: Font, % " s"GUI_MenuParam.FontSize
        Gui, ModManager_Menu: Add, TreeView, % "x"MM_W*0.01 " y"MM_H*0.5 " w"MM_W*0.6 " h"MM_H*0.425 " c"GUI_Text1 " gTreeView_Handler +Background"GUI_Background2 " -Tabstop -Buttons +Checked +HwndhTreeView AltSubmit"
        ;--------------------------------------------------
        ; Создание списка программ
        for A_Loop, A_key in textTreeMain
            idTreeMain[A_Loop] := TV_Add(A_key, 0, (settingTreeMain[A_Loop] ? "Check Expand" : "-Check -Expand"))
        ; Создание списка разделов
        for A_Loop, A_key in textTreeHeadlines
            for B_Loop, B_key in A_key
                idTreeHeadlines[A_Loop, B_Loop] := TV_Add(B_key, idTreeMain[A_Loop], (settingTreeHeadlines[A_Loop, B_Loop] ? "Check" : "-Check") " Expand")
        ; Создание списков
        for A_Loop, A_key in textTreeList
            for B_Loop, B_key in A_key
                for C_Loop, C_key in B_key
                    idTreeList[A_Loop, B_Loop, C_Loop] := TV_Add(C_key, idTreeHeadlines[A_Loop, B_Loop], (settingTreeList[A_Loop, B_Loop, C_Loop] ? "Check" : "-Check"))

;;;;;;;;;; End ;;;;;;;;;; 
    A_Loop := "", A_key := "", B_Loop := "", B_key := "", C_Loop := "", C_key := ""
Return

;;;;;;;;;; Functions ;;;;;;;;;;
    TreeView_Handler() {
        global
        local numMain, numHeadlines, numList, aFlag, aCheckBox
        local A_Loop, A_key, B_Loop, B_key, C_Loop, C_key
        if (A_GuiEvent != "Normal")
            Return
        for numMain, A_key in idTreeMain {
            if (A_EventInfo = A_key) {
                settingTreeMain[numMain] := !settingTreeMain[numMain]
                aFlag := "Main"
                Break
            }
            for numHeadlines, B_key in idTreeHeadlines[numMain] {
                if (A_EventInfo = B_key) {
                    settingTreeHeadlines[numMain, numHeadlines] := !settingTreeHeadlines[numMain, numHeadlines]
                    aFlag := "Headlines"
                    Break, 2
                }
                for numList, C_key in idTreeList[numMain, numHeadlines] 
                    if (A_EventInfo = C_key) {
                        settingTreeList[numMain, numHeadlines, numList] := !settingTreeList[numMain, numHeadlines, numList]
                        aFlag := "List"
                        Break, 3
                    }
            }
        }
        aCheckBox := (TV_Get(A_EventInfo, "Checked") ? True : False)
        switch aFlag {
            case "Main" : TV_Modify(idTreeMain[numMain], aCheckBox ? "Expand" : "-Expand")
            case "Headlines" :
                if (soloFlag[numMain, numHeadlines] && aCheckBox) {
                        TV_Modify(A_EventInfo, "-Check")
                        settingTreeHeadlines[numMain, numHeadlines] := False
                } Else
                    for A_Loop, A_key in idTreeList[numMain, numHeadlines] {
                        TV_Modify(A_key, aCheckBox ? "Check" : "-Check")
                        settingTreeList[numMain, numHeadlines, A_Loop] := aCheckBox
                    }
            case "List" :
                if soloFlag[numMain, numHeadlines]
                    for A_Loop, A_key in idTreeList[numMain, numHeadlines] {
                        if (A_key = A_EventInfo) {
                            TV_Modify(idTreeHeadlines[numMain, numHeadlines], "Check")
                            settingTreeHeadlines[numMain, numHeadlines] := True
                            Continue
                        }
                        TV_Modify(A_key, "-Check")
                        settingTreeList[numMain, numHeadlines, A_Loop] := False
                    }
                if !aCheckBox {
                    TV_Modify(idTreeHeadlines[numMain, numHeadlines], "-Check")
                    settingTreeHeadlines[numMain, numHeadlines] := False
                }
        }
        BeforeExiting_Menu()
    }

    GUI_Handler() {
        global
        switch A_GuiControl {
            case "RGF1": {
                local A_GameFolder
                FileSelectFolder, A_GameFolder, % (GameFolder = " Не указана" ? "" : "*" GameFolder), 0, Укажите путь до папки с игрой.
                if (ErrorLevel || !FileExist(A_GameFolder "\Tanki.exe")) {
                    GameFolder := (FileExist(GameFolder "\Tanki.exe")) ? GameFolder : " Не указана"
                    if !ErrorLevel
                        MsgBox, 16, World of Tanks : DMod manager, Папка с игрой указана неверно!
                }
                else 
                    GameFolder := A_GameFolder
                GuiControl, ModManager_Menu: Text, RGF2,` %GameFolder%
                CheckVersion("Game")
                GuiControl, ModManager_Menu: Text, vText1,` %vGame%
                GuiControl, ModManager_Menu: Text, vText2,` %vDModInGame%
            }
            case "CB1": {
                Gui, Submit, NoHide
                if (CB1 && (GameFolder = " Не указана"))  {
                    GuiControl, ModManager_Menu:, CB1, 0
                    MsgBox, 16, World of Tanks : DMod manager, Папка с игрой не указана!
                }   
            }
            case "CB2": {
                Gui, Submit, NoHide
            }
            case "CB3": {
                Gui, Submit, NoHide
                ManageStartup(A_WorkingDir "\libs\Autorun.ahk", (CB3 ? "add" : "remove"), "DModManager_")
            }
            case "ConfigSettings" : {
                local Editor := ProgramSearch("Visual Studio Code", "Notepad++")
                Run, % """" (Editor ? Editor : "Notepad.exe") """ """ CheckingFiles("File", False, "ConfigEditor.ahk") """"
            }
            case "Button1" : {
                IniWrite, Menu, % CheckingFiles("File", False, "SavedSettings.ini"), Installer, LaunchModifier
                Run, % """" ProgramSearch("AutoHotkey 1") """ """ A_ScriptDir "\libs\Installer.ahk"""
            }
            case "Button2", "Button3": {
                local A_UserDownloadFolder 
                FileSelectFolder, A_UserDownloadFolder, *%UserDownloadFolder%, 0, Выберите папку для сохранения.
                if !ErrorLevel {
                    ;--------------------------------------------------
                    local PlaceForTheText := "Text text text text text text text text text text text text"
                    UpdateDGP({"Transparency" : 100, "Blur" : 255, "FontSize" : 25, "BorderColor" : "ff5100", "BorderSize" : 2})
                    GuiInGame("Start", "UserDownload")
                        Gui, UserDownload: Add, Text, xm ym +Center cYellow vT1, %PlaceForTheText%
                        GuiControl, UserDownload: Text, T1, World of Tanks : DMod manager
                        Gui, UserDownload: Add, Text, xm y+m +Center vStatusGUI, %PlaceForTheText%
                        GuiControl, UserDownload: Text, StatusGUI, Ожидание начала загрузки
                    GuiInGame("End", "UserDownload", {"pos" : ["center", (A_ScreenHeight / 7)]})
                    ;--------------------------------------------------
                    UserDownloadFolder := A_UserDownloadFolder
                    switch A_GuiControl {
                        case "Button2" : 
                            GuiControl, UserDownload: Text, StatusGUI, Загрузка D Mod %vDModInServer%
                            DownloadFile(vDMod_LWR, UserDownloadFolder "\D Mod " vDModInServer ".exe")
                        case "Button3" : 
                            GuiControl, UserDownload: Text, StatusGUI, Загрузка D Mod Texture %vDModTextureInServer%
                            DownloadFile(vDModTexture_LWR, UserDownloadFolder "\D Mod Texture " vDModTextureInServer ".exe")
                    }
                    GuiInGame("Destroy", "UserDownload")
                }
            }
        }
    }

    ManageStartup(scriptPath, action, prefix = "") {
        ; Получаем имя файла без расширения для ярлыка
        SplitPath, scriptPath, fileName, fileDir, fileExt, fileNameNoExt
        
        ; Путь к папке автозагрузки
        shortcutPath := A_Startup . "\" . prefix . fileNameNoExt . ".lnk"
        
        switch action {
            ; Добавление в автозагрузку
            case "add": {
                ; Проверяем существование исходного файла
                if !FileExist(scriptPath)
                    return false

                ; Если есть старый ярлык - удаляем
                if FileExist(shortcutPath)
                    FileDelete, %shortcutPath%

                ; Создаем новый ярлык
                FileCreateShortcut, %scriptPath%, %shortcutPath%, %fileDir%

                ; Возвращаем результат создания
                return !ErrorLevel
            }

            ; Удаление из автозагрузки
            case "remove": {
                if FileExist(shortcutPath) {
                    FileDelete, %shortcutPath%
                    return !ErrorLevel
                }
                return true ; Ярлыка и не было - считаем успехом
            }

            ; Проверка наличия рабочего ярлыка
            case "check": {
                ; Проверяем существование исходного файла
                if !FileExist(scriptPath)
                    return false

                ; Проверяем существование ярлыка
                if !FileExist(shortcutPath)
                    return false

                ; Получаем информацию о ярлыке
                FileGetShortcut, %shortcutPath%, targetPath

                ; Проверяем существование целевого файла
                if !FileExist(targetPath)
                    return false

                ; Сравниваем пути (без учета регистра)
                StringLower, scriptPath, scriptPath
                StringLower, targetPath, targetPath

                return (scriptPath = targetPath)
            }

            ; Если неизвестное действие
            default:
                return false
        }
    }

    SafeRandom(min = 0, max = 2147483647) {
        Loop, {
            Random, number, min, max
            if ((number >= min) && (number <= max))
                Break
        }
        Return number
    }

;;;;;;;;;; Exit ;;;;;;;;;;
    BeforeExiting_Menu() {
        global
        local FilePath := CheckingFiles("File", False, "SavedSettings.ini")
        local A_Loop, A_key, B_Loop, B_key, C_Loop, C_key 
        for A_Loop, A_key in settingTreeMain {
            IniWrite, %A_key%, %FilePath%, Tree Settings, % "settingTreeMain-" . A_Loop
            for B_Loop, B_key in settingTreeHeadlines[A_Loop] {
                IniWrite, %B_key%, %FilePath%, Tree Settings, % "settingTreeHeadlines-" . A_Loop . "-" B_Loop
                for C_Loop, C_key in settingTreeList[A_Loop, B_Loop] {
                    IniWrite, %C_key%, %FilePath%, Tree Settings, % "settingTreeList-" . A_Loop . "-" B_Loop "-" C_Loop
                }
            }
        }
        IniWrite, %GameFolder%, %FilePath%, Main Settings, GameFolder
        IniWrite, %CB1%, %FilePath%, Main Settings, CB1
        IniWrite, %CB2%, %FilePath%, Main Settings, CB2
        IniWrite, %UserDownloadFolder%, %FilePath%, Main Settings, UserDownloadFolder
        IniWrite, Menu, %FilePath%, Installer, LaunchModifier
    }

    ModManager_MenuGuiClose() {
        Gui, ModManager_Menu: Destroy
        ExitApp
    }
    