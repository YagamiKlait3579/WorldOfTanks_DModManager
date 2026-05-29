;;;;;;;;;; Loading ;;;;;;;;;;

;;;;;;;;;; Variables ;;;;;;;;;;
    global vDModInServer, lDModInServer, vDModTextureInServer, lDModTextureInServer
    settingTreeMain := [], settingTreeHeadlines := [], settingTreeList := []
    soloFlag := [[False, True, True, False, False, True], [False, True, False]]
    ;--------------------------------------------------
    textTreeMain  := ["D Mod", "D Mod Texture Mods"]
    ;--------------------------------------------------
    textTreeHeadlines := [["Разрешенные", "Прицелы/Сведения", "Счетчик нанесенного урона", "Еще моды (на любителя)", "Запрещенные", "Автоботы/AimBot"]
                     ,["Моды", "Улучшение видимости", "Отключение эффектов и улучшение производительности"]]
    ;--------------------------------------------------
    textTreeList      := []
    textTreeList[1,1] := ["Командирская камера", "Винтик", "Панель урона", "Заблокированный броней урон", "Игформационная панель", "Калькулятор эффективности в бою"
                         ,"Таймер сведения орудия в бою", "Рейтинг отметок на стволе", "Калькулятор бронепробития", "Углы горизонтальной наводки", "Рейтинг игроков в бою"
                         ,"ХП и набитый урон в ушах", "Иконки танков по цвету класса техники", "Статистика за сессию Draug"]
    textTreeList[1,2] := ["Прицел от Draug v.1", "Прицел от Draug v.1. + сведение Fatality", "Прицел Taipan", "Гарпун Lite"]
    textTreeList[1,3] := ["Минималистичный лог", "Подробный лог"]
    textTreeList[1,4] := ["Фиксатор прицела", "Маркер открытой цели", "Пересадка экипажа", "Ассист засвета и оглушения", "Блокировка выстрела по трупам", "Наблюдатель"
                         ,"Улучшить обзор в снайперском режиме", "Светлячек", "Шанс на победу", "Стволик хаоса", "Уменьшить круг сведения в 2 раза", "Знак мастера в ушах"
                         ,"Место сведения союзной арты", "Отключения тумана"]
    textTreeList[1,5] := ["Тундра", "Перезарядка противников", "Снайперский режим для артилерии", "Попадание без засвета", "Лазерная указка", "Целеуказатель"
                         ,"Контур - рентген", "Разрушенные объекты на миникарте", "Танки вне зоны отрисовки видимости", "Удаление простреливаемых объектов", "Незабудка"
                         ,"Красные шары для арты", "Маркер упреждения для артиллерии", "Направление стволов на миникарте", "Таймер последнего стрелявшего"]
    textTreeList[1,6] := ["Автоприцел с захватом цели за препятствием", "Аимбот джедай", "Аимбот шайтан", "Аимбот ванга.", "Аимбот Evil"]
    ;--------------------------------------------------
    textTreeList[2,1] := ["Шкурки с зонами пробития для танков", "Цветные декали попаданий", "Разлет оскольков фугаса", "Тактическая миникарта позиций"]
    textTreeList[2,2] := ["Отключение тумана", "Пасмурная погода", "Звездное небо"]
    textTreeList[2,3] := ["Дым и пламя от выстрелов", "Дым и пламя из выхлопных труб", "Дым от уничтоженных танков", "Облака", "Тень под танком"
                         ,"Эффекты взрывов снарядов и попадания в объекты", "Эффекты попадания по танкам", "Эффекты уничтожения танков"]
    ;--------------------------------------------------
    ;SettingsUploading()
    ;CheckVersion()

;;;;;;;;;; Additional functions ;;;;;;;;;;
    SettingsUploading() {
        global
        local FilePath, aVar
        local A_Loop, A_key, B_Loop, B_key, C_Loop, C_key
        if (!FilePath := CheckingFiles("File", False, "SavedSettings.ini")) {
            FilePath := A_WorkingDir . "\libs\SavedSettings.ini"
            FileAppend, , %FilePath%
        }
        for A_Loop, A_key in textTreeMain {
            IniRead, aVar, %FilePath%, Tree Settings, % "settingTreeMain-" . A_Loop
            settingTreeMain[A_Loop] := (aVar = "ERROR" ? False : aVar)
            for B_Loop, B_key in textTreeHeadlines[A_Loop] {
                IniRead, aVar, %FilePath%, Tree Settings, % "settingTreeHeadlines-" . A_Loop . "-" B_Loop
                settingTreeHeadlines[A_Loop, B_Loop] := (aVar = "ERROR" ? False : aVar)
                for C_Loop, C_key in textTreeList[A_Loop, B_Loop] {
                    IniRead, aVar, %FilePath%, Tree Settings, % "settingTreeList-" . A_Loop . "-" B_Loop "-" C_Loop
                    settingTreeList[A_Loop, B_Loop,C_Loop] := (aVar = "ERROR" ? False : aVar)
                }
            }
        }
        IniRead, aVar, %FilePath%, Main Settings, GameFolder
        GameFolder := (!FileExist(aVar) ? " Не указана" : aVar)
        IniRead, CB1, %FilePath%, Main Settings, CB1, 0
        IniRead, CB2, %FilePath%, Main Settings, CB2, 0
        IniRead, UserDownloadFolder, %FilePath%, Main Settings, UserDownloadFolder, %A_Space%
        ;--------------------------------------------------
        IniRead, LaunchModifier, %FilePath%, Installer, LaunchModifier, Menu
    } 
    
;;;;;;;;;; Checking versions ;;;;;;;;;; 
    CheckVersion(task = "All", GUI_report = "") {
        global
        local A_Loop, A_Key
        if ((task = "All" || task = "Server" || task = "Downloads") && !GUI_report) {
            local PlaceForTheText := "Text text text text text text text text text text text text"
            UpdateDGP({"Transparency" : 100, "Blur" : 255, "FontSize" : 25, "BorderColor" : "ff5100", "BorderSize" : 2})
            GuiInGame("Start", "CheckVersion")
                Gui, CheckVersion: Add, Text, xm ym +Center cYellow vT1, %PlaceForTheText%
                GuiControl, CheckVersion: Text, T1, World of Tanks : DMod manager
                Gui, CheckVersion: Add, Text, xm y+m +Center vStatusGUI, %PlaceForTheText%
                GuiControl, CheckVersion: Text, StatusGUI,
            GuiInGame("End", "CheckVersion", {"pos" : ["center", (A_ScreenHeight / 7)]})
        }
        ; Проверка версии модов на сервере
        if (task = "All" || task = "Server") {
            GuiInGame("Edit", (GUI_report ? GUI_report : "CheckVersion"), {"id" : "StatusGUI", "Text" : "Проверка версии модов на сервере"})
            local versionVar, link, result, serverChecks := []
            serverChecks[1] := { "url": "https://draug.ru/info_sky.html"
                               , "versionVar": "vDModInServer" 
                               , "Link": "lDModInServer" }
            serverChecks[2] := { "url": "https://draug.ru/texture_pack.html"
                               , "versionVar": "vDModTextureInServer"
                               , "Link": "lDModTextureInServer" }                 
            for A_Loop, A_Key in serverChecks {
                result := CheckServerVersion(A_Key.url)
                if (result != "") {
                    versionVar := A_Key.versionVar
                    %versionVar% := (result.Version ? result.Version : "ERROR 1")
                    link := A_Key.link
                    %link% := (result.link ? result.link : "ERROR")
                }
            }
        }
        ; Проверка установщика в скрипте
        if (task = "All" || task = "Downloads") {
            local downloads := []
            downloads[1] := { "linkVar": lDModInServer
                            , "serverVer": vDModInServer
                            , "fileMask": "D Mod v.*.exe"
                            , "fileName": "D Mod "
                            , "type": "Mod" }               
            downloads[2] := { "linkVar": lDModTextureInServer
                            , "serverVer": vDModTextureInServer
                            , "fileMask": "D Mod Texture v.*.exe"
                            , "fileName": "D Mod Texture "
                            , "type": "Texture" }
            for A_Loop, A_Key in downloads {
                GuiInGame("Edit", (GUI_report ? GUI_report : "CheckVersion"), {"id" : "StatusGUI", "Text" : "Проверка версии " A_Key.fileName " в скрипте"})
                if !A_Key.linkVar
                    continue
                FoundCurrentVersion := false
                Loop, Files, % A_WorkingDir . "\libs\Downloads\" . A_Key.fileMask
                {
                    if RegExMatch(A_LoopFileName, "v\.(\d+\.\d+)", FileVersionMatch) 
                        if (A_Key.serverVer = FileVersionMatch && !FoundCurrentVersion)
                            FoundCurrentVersion := true
                        else
                            FileDelete, %A_LoopFileFullPath%
                }
                if !FoundCurrentVersion {
                    downloadPath := A_WorkingDir . "\libs\Downloads\" . A_Key.fileName . A_Key.serverVer . ".exe"
                    GuiInGame("Edit", (GUI_report ? GUI_report : "CheckVersion"), {"id" : "StatusGUI", "Text" : "Загрузка нового " A_Key.fileName})
                    DownloadFile(A_Key.linkVar, downloadPath)
                }
            }
        }
        ; Поиск версии игры и DMod
        if (task = "All" || task = "Game") {
            local fileChecks, fileContent, versionVar
            Loop, 2 {
                if (GameFolder = " Не указана") {
                    vGame := vDModInGame := "ERROR: 1"
                    Break
                }
                switch A_Index {
                    case 1: 
                        fileChecks := { "path"        : GameFolder . "\version.xml"
                                      , "versionVar"  : "vGame"
                                      , "regex"       : "<version>\s*v\.(\d+\.\d+\.\d+\.\d+)"
                                      , "errorPrefix" : "vGame" }       
                    case 2: 
                        fileChecks := { "path"        : GameFolder . "\res_mods\" . StrReplace(vGame, "v.") . "\scripts\client\gui\mods\mod_dmodupdater.json"
                                      , "versionVar"  : "vDModInGame"
                                      , "regex"       : """LocalVer""\s*:\s*""(\d+\.\d+)"""
                                      , "errorPrefix" : "vDModInGame" }
                }
                if !FileExist(fileChecks.path) {
                    errorVar := fileChecks.errorPrefix
                    %errorVar% := "ERROR: 1"
                    continue
                }
                FileRead, fileContent, % fileChecks.path
                if ErrorLevel {
                    errorVar := fileChecks.errorPrefix
                    %errorVar% := "ERROR: 2"
                    continue
                }
                if RegExMatch(fileContent, fileChecks.regex, match) {
                    versionVar := fileChecks.versionVar
                    %versionVar% := "v." match1
                } else {
                    errorVar := fileChecks.errorPrefix
                    %errorVar% := "ERROR: 3"
                }
            }
        }
        if !GUI_report
            GuiInGame("Destroy", "CheckVersion")
    }

;;;;;;;;;; Internet ;;;;;;;;;; 
    CheckServerVersion(url) {
        try {
            whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
            whr.Open("GET", url, true)
            whr.Send()
            whr.WaitForResponse()

            if (whr.Status = 200) {
                html := whr.ResponseText

                ; Ищем ссылку перед фразой "Перейти к скачиванию"
                if RegExMatch(html, "i)href=""([^""]+\.exe)""[^>]*>[^<]*Перейти к скачиванию", match) {
                    actualLink := match1

                    ; Извлекаем версию из ссылки
                    if RegExMatch(actualLink, "v\.(\d+\.\d+)\.exe$", verMatch) {
                        return { "Link" : actualLink, "Version" : "v." . verMatch1 }
                    }
                }   
            }
        } catch e {
            ; Ошибка при получении страницы
        }
        return ""
    }

    DownloadFile(url, savePath) {
        http := ComObjCreate("MSXML2.XMLHTTP.6.0")
        http.Open("GET", url, false)
        http.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120.0.0.0")
        http.SetRequestHeader("Referer", "https://draug.ru/")
        http.Send()
        
        if (http.Status = 200) {
            ado := ComObjCreate("ADODB.Stream")
            ado.Type := 1
            ado.Open()
            ado.Write(http.ResponseBody)
            ado.SaveToFile(savePath, 2)
            ado.Close()
            return true
        }
        return false
    }