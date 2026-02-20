;;;;;;;;;; Loading ;;;;;;;;;;
    OnExit("BeforeExiting")

;;;;;;;;;; Variables ;;;;;;;;;;
    global CSV_TimeStamp
    settingTreeMain := [], settingTreeHeadlines := [], settingTreeList := []
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
    textTreeList[1,6] := ["Автоприцел с захватом цели за препятствием", "Аимбот джедай", "Аимбот шайтан"]
    ;--------------------------------------------------
    textTreeList[2,1] := ["Шкурки с зонами пробития для танков", "Цветные декали попаданий", "Разлет оскольков фугаса", "Тактическая миникарта позиций"]
    textTreeList[2,2] := ["Отключение тумана", "Пасмурная погода", "Звездное небо"]
    textTreeList[2,3] := ["Дым и пламя от выстрелов", "Дым и пламя из выхлопных труб", "Дым от уничтоженных танков", "Облака", "Тень под танком"
                         ,"Эффекты взрывов снарядов и попадания в объекты", "Эффекты попадания по танкам", "Эффекты уничтожения танков"]
    ;--------------------------------------------------
    DMod_BaseURL         := "https://draug.ru/dmod/D%20Mod%20v.1.0.exe"
    DMod_BaseName        := "D Mod "
    DModTexture_BaseURL  := "https://draug.ru/dmod/D%20Mod%20Texture%20Mods%20v.1.0.exe"
    DModTexture_BaseName := "D Mod Texture "
    ;--------------------------------------------------
    SettingsUploading()
    CheckVersion()

;;;;;;;;;; Additional functions ;;;;;;;;;;
    fMouseClick(x, y, t = 25) {
        fSetCursor(x, y)
        lSleep(t)
        fMouseInput("Left")
    }

    SettingsUploading() {
        global
        local FilePath, aVar
        local A_Loop, A_key, B_Loop, B_key, C_Loop, C_key
        FilePath := CheckingFiles("File", False, "SavedSettings.ini")
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
        IniRead, vDModInServer, %FilePath%, Main Settings, vDModInServer, %A_Space%
        IniRead, vDModTextureInServer, %FilePath%, Main Settings, vDModTextureInServer, %A_Space%
        ; LWR = last working link
        IniRead, vDMod_LWR, %FilePath%, Main Settings, vDMod_LWR, %A_Space%
        IniRead, vDModTexture_LWR, %FilePath%, Main Settings, vDModTexture_LWR, %A_Space%
        IniRead, vDModInGame, %FilePath%, Main Settings, vDModInGame, %A_Space%
        IniRead, vGame, %FilePath%, Main Settings, vGame, %A_Space%
        IniRead, CSV_TimeStamp, %FilePath%, Main Settings, CSV_TimeStamp, 1        
    } 
    
;;;;;;;;;; Checking versions ;;;;;;;;;; 
    CheckVersion(task = "All") {
        global
        local A_Loop, A_Key
        if (task = "All" || task = "Server" || task = "Downloads") {
            local PlaceForTheText := "Text text text text text text text text text text text text"
            UpdateDGP({"Transparency" : 100, "Blur" : 255, "FontSize" : 25, "BorderColor" : "ff5100", "BorderSize" : 2})
            GuiInGame("Start", "CheckVersion")
                Gui, CheckVersion: Add, Text, xm ym +Center cYellow vT1, %PlaceForTheText%
                GuiControl, CheckVersion: Text, T1, World of Tanks : DMod manager
                Gui, CheckVersion: Add, Text, xm y+m +Center vStatusGUI, %PlaceForTheText%
                GuiControl, CheckVersion: Text, StatusGUI,
            GuiInGame("End", "CheckVersion", {"pos" : ["center", (A_ScreenHeight / 5)]})
        }
        ; Проверка версии модов на сервере
        if (task = "All" || task = "Server") {
            GuiInGame("Edit", "CheckVersion", {"id" : "StatusGUI", "Text" : "Проверка версии модов на сервере"})
            local serverChecks, result
            serverChecks := []
            serverChecks[1] := { "url": vDMod_LWR ? vDMod_LWR : DMod_BaseURL
                               , "linkVar": "vDMod_LWR"
                               , "versionVar": "vDModInServer" }
            serverChecks[2] := { "url": vDModTexture_LWR ? vDModTexture_LWR : DModTexture_BaseURL
                               , "linkVar": "vDModTexture_LWR"
                               , "versionVar": "vDModTextureInServer" }                 
            for A_Loop, A_Key in serverChecks {
                result := CheckServerVersion(A_Key.url)
                if (result != "timeout") {
                    linkVar := A_Key.linkVar
                    %linkVar% := (result.Link ? result.Link : "")
                    versionVar := A_Key.versionVar
                    %versionVar% := (result.Version ? result.Version : "ERROR 1")
                }
            }
        }
        ; Проверка установщика в скрипте
        if (task = "All" || task = "Downloads") {
            GuiInGame("Edit", "CheckVersion", {"id" : "StatusGUI", "Text" : "Проверка установщика в скрипте"})

            Loop, Files, % A_Scriptdir . "\" . FileNamePattern . " v.*.exe"
            {
                ; Извлекаем версию из имени файла
                if (RegExMatch(A_LoopFileName, "v\.(\d+\.\d+)", FileVersionMatch)) {
                    FileVersion := FileVersionMatch1

                    ; Сравниваем версии
                    if ((FileVersion = LinkVersion) && !FoundCurrentVersion)
                        FoundCurrentVersion := true
                    else 
                        FileDelete, %A_LoopFileFullPath%
                }
            }
        }
        ; Поиск версии игры и DMod
        if (task = "All" || task = "Game") {
            local fileChecks, fileContent, versionVar
            Loop, 2 {
                if (GameFolder = " Не указана") {
                    vGame := vDModInGame := "Укажите папку с игрой"
                    Break
                }
                switch A_Index {
                    case 1: 
                        fileChecks := { "path"        : GameFolder . "\version.xml"
                                      , "versionVar"  : "vGame"
                                      , "regex"       : "<version>\s*(v\.\d+\.\d+\.\d+\.\d+)"
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
                    %versionVar% := match1
                } else {
                    errorVar := fileChecks.errorPrefix
                    %errorVar% := "ERROR: 3"
                }
            }
        }
        GuiInGame("Destroy", "CheckVersion")
    }

;;;;;;;;;; Internet ;;;;;;;;;; 
    CheckServerVersion(CurrentLink, maxMajor = 10, maxMinor = 10, timeout = 60) {
        if (WorldTimePassed(CSV_TimeStamp,, "sec") < timeout)
            Return "timeout"
        WorldTimeStamp(CSV_TimeStamp) ; CSV = Check Server Version

        RegExMatch(CurrentLink, "^(.*v\.)(\d+)\.(\d+)(\.exe)$", Match)
        ; Match1 = BaseURL
        ; Match2 = CurrentMajor (мажорная версия)
        ; Match3 = CurrentMinor (минорная версия)
        ; Match4 = FileExtension
                
        ; Ищем в мажорных версиях (сначало в текущей, далее по нарастающей до 10, потом с 1 до текущей)
        Loop, %maxMajor% {
            NextMajor := (Match2 + (A_Index - 1)) > maxMajor ? ((Match2 + (A_Index - 1)) - maxMajor) : (Match2 + (A_Index - 1))
            Loop, %maxMinor% {
                ; Ищем в минорных версиях (сначало в текущей, далее по нарастающей до 10, потом с 1 до текущей)
                NextMinor := (Match3 + A_Index) >= maxMinor ? ((Match3 + A_Index) - maxMinor) : (Match3 + A_Index)
                NewLink := Match1 . NextMajor . "." . NextMinor . Match4
                if CheckLink(NewLink) 
                    Return { "Link" : NewLink, "Version" : NextMajor "." NextMinor}
            }
        }
        return ""  ; Не нашли новую версию
    }

    CheckLink(url) {
        ; Функция проверки доступности ссылки
        try {
            ; Создаем HTTP запрос
            whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
            whr.Open("HEAD", url, true)
            whr.Send()
            whr.WaitForResponse()

            ; Проверяем статус ответа (200 = OK)
            if (whr.Status = 200)
                return true
            else
                return false
        }
        catch {
            ;MsgBox, 16, World of tanks - Mod manager, Не удалось проверить ссылку %url%
            return false
        }
    }

    DownloadFile(url, savePath) {
        http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        http.Open("GET", url, false)
        http.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120.0.0.0")
        http.SetRequestHeader("Referer", "https://draug.ru/")
        http.Send()
        http.WaitForResponse()
        
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

;;;;;;;;;; Exit ;;;;;;;;;;
    BeforeExiting() {
        global
        local FilePath
        FilePath := CheckingFiles("File", False, "SavedSettings.ini")
        IniWrite, %vDModInServer%, %FilePath%, Main Settings, vDModInServer
        IniWrite, %vDModTextureInServer%, %FilePath%, Main Settings, vDModTextureInServer
        IniWrite, %vDMod_LWR%, %FilePath%, Main Settings, vDMod_LWR
        IniWrite, %vDModTexture_LWR%, %FilePath%, Main Settings, vDModTexture_LWR
        IniWrite, %vDModInGame%, %FilePath%, Main Settings, vDModInGame
        IniWrite, %vGame%, %FilePath%, Main Settings, vGame
        IniWrite, %CSV_TimeStamp%, %FilePath%, Main Settings, CSV_TimeStamp
    }