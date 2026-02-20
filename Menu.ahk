;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\CoreLibsFor_AHK\BaseLibs\Header.ahk
    OnExit("BeforeExiting_Menu")

;;;;;;;;;; Variables ;;;;;;;;;;
    idTreeMain := [], idTreeHeadlines := [], idTreeList := []
    soloFlag := [[False, True, True, False, False, True], [False, True, False]]

;;;;;;;;;; Gui ;;;;;;;;;;
    ;*** GUI Variables ***
        GUI_Text1 := "E6F1FF"
        GUI_Text2 := "19e1ff"
        GUI_Text3 := "ff0000"   
        GUI_Background := "202020"
        GUI_Background2 := "505050"

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
        Gui, ModManager_Menu: Add, Text, % " x"MM_W*0.01 " y"MM_H*0.01 " w"MM_W*0.25 " c"GUI_Text2 " +Section +Right +HwndhText1" ,` Последняя версия DMod: `
        Gui, ModManager_Menu: Add, Text, % " x+ yp w"MM_W*0.1 " c"GUI_Text3 " +Left +HwndhText2",` %vDModInServer% `
        T1_H := GuiLineWidth(hText1)
        T2_H := GuiLineWidth(hText2)
        ;--------------------------------------------------
        Gui, ModManager_Menu: Add, Text, % " xs y"MM_H*0.05 " w"T1_H " +Section +Right c"GUI_Text2,` Папка с игрой: `
        Gui, ModManager_Menu: Add, Text, % " x+ ys w"T2_H " +Center c"GUI_Text3 " gRegisterGameFolder", Обзор
        Gui, ModManager_Menu: Add, Text, % " xs y+ w"T1_H+T2_H " +Left c"GUI_Text3 " +Border vRGF2",` %GameFolder%
        ;--------------------------------------------------
        Gui, ModManager_Menu: Add, Text, % " xs y+ w"T1_H " +Right c"GUI_Text2,` Версия игры:
        Gui, ModManager_Menu: Add, Text, % " x+ yp w"T2_H " +Left vvText1 c"GUI_Text3,` %vGame%
        Gui, ModManager_Menu: Add, Text, % " xs y+ w"T1_H " +Right c"GUI_Text2,` Версия DMod в игре:
        Gui, ModManager_Menu: Add, Text, % " x+ yp w"T2_H " +Left vvText2 c"GUI_Text3,` %vDModInGame%
        ;--------------------------------------------------
        Gui, ModManager_Menu: Add, Text, xs y+ +HwndhCB1,`   
        Gui, ModManager_Menu: Add, Checkbox, x+ yp +HwndhCB2,`

        Gui, ModManager_Menu: Add, Text, % " x+ yp w"(T1_H + T2_H - GuiLineWidth(hCB1, hCB2)) " +Left c"GUI_Text2
        ,` Ставить дополнительные моды? `



    ;*** End ***    
        Gui, ModManager_Menu: Add, Picture, % "x0 y0 w" (A_ScreenWidth/2) " h-1", % CheckingFiles("File", False, "WoT_BG_5.png")
    ;*** List ***
        Gui, ModManager_Menu: Add, TreeView, % "x"MM_W*0.01 " y"MM_H*0.525 " w"MM_W*0.6 " h"MM_H*0.4 " c"GUI_Text1 " gTreeView_Handler +Background"GUI_Background " -Buttons +Checked +HwndhTreeView AltSubmit"
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
    ;WinSet, TransColor, 202020 ;, ahk_id %hText1%

    GuiInGame("Start", "TestGUI")
        Gui, TestGUI: Add, Text, xm ym +Center vT1, Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test
        GuiControl, TestGUI: Text, T1, - - - - -
        Gui, TestGUI: Add, Text, xm y+m +Center vT2, Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test
        GuiControl, TestGUI: Text, T2, - - -
        Gui, TestGUI: Add, Text, xm y+m +Center vT3, Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test
        GuiControl, TestGUI: Text, T3, -
    GuiInGame("End", "TestGUI", {"pos" : [(A_ScreenWidth / 3) * 2, (A_ScreenHeight / 8) * 7]})


    ;GuiInGame("Edit", "TestGUI", {"id" : "T1", "Text" : "---"})
    ;GuiInGame("Edit", "TestGUI", {"id" : "T2", "Text" : "---"})
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
    }

    RegisterGameFolder() {  
        global
        local A_GameFolder
        FileSelectFolder, A_GameFolder, % (GameFolder = " Не указана" ? "" : "*"GameFolder), 0, Укажите путь до папки с игрой.
        if A_GameFolder {
            GameFolder := A_GameFolder
            GuiControl, ModManager_Menu: Text, RGF2,` %GameFolder%
            CheckVersion("Game")
            GuiControl, ModManager_Menu: Text, vText1,` %vGame%
            GuiControl, ModManager_Menu: Text, vText2,` %vDModInGame%
        }
    }

;;;;;;;;;; Exit ;;;;;;;;;;
    BeforeExiting_Menu() {
        global
        local FilePath
        local A_Loop, A_key, B_Loop, B_key, C_Loop, C_key
        FilePath := CheckingFiles("File", False, "SavedSettings.ini")
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
    }

    ModManager_MenuGuiClose() {
        Gui, ModManager_Menu: Destroy
        ExitApp
    }
    