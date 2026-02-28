;;;;;;;;;; Loading ;;;;;;;;;;
    #include %A_Scriptdir%\libs\CoreLibsFor_AHK\BaseLibs\Header.ahk
    ;--------------------------------------------------
    ;#IfWinActive, 
    ;global PWN := "" ; Program window name
    ;CheckForUpdates("YagamiKlait3579", "PrivateScriptsOn_AHK", "main", CheckingFiles("File", False, "Header.ahk"))
    OnExit("BeforeExiting")
    InstallList := {}

;;;;;;;;;; Setting ;;;;;;;;;;
    DownloadFolder    := A_Desktop    ; Путь куда ваш браузер скачивает файлы
    A_Image           := 25           ; Отклонения от оригинала картинки (от 0 до 255)
    global gTimeout   := 60           ; Ожидание сервера для модов (сек.)

    ;--------------------------------------------------
    ; НАСТРОЙКИ МОД-ПАКА
    ;--------------------------------------------------
        CheckingVersion_M := True         ; Вкл\выкл установки мод-пака (True — включено, False — выключено)
        StartLink_M       := "https://draug.ru/dmod/D%20Mod%20v.1.0.exe"
        FileName_M        := "D Mod"
        ;;;;;;;;;; Разрешенные ;;;;;;;;;;
        ; !Если включить установку всего раздела, настроки подраздела будут проигнорированны.
        InstallList[110]  := {"Status" : False, "Name" : "Разрешенные"}
            InstallList[111]  := {"Status" : False, "Name" : "Командирская камера"}
            InstallList[112]  := {"Status" : True , "Name" : "Винтик"}
            InstallList[113]  := {"Status" : False, "Name" : "Панель урона"}
            InstallList[114]  := {"Status" : False, "Name" : "Заблокированный броней урон"}
            InstallList[115]  := {"Status" : False, "Name" : "Информационная панель"}
            InstallList[116]  := {"Status" : False, "Name" : "Калькулятор эффективности в бою"}
            InstallList[117]  := {"Status" : True , "Name" : "Таймер сведения орудия в бою"}
            InstallList[118]  := {"Status" : False, "Name" : "Рейтинг отметок на стволе"}
            InstallList[119]  := {"Status" : True , "Name" : "Калькулятор бронепробития"}
            InstallList[1110] := {"Status" : False, "Name" : "Углы горизонтальной наводки"}
            InstallList[1111] := {"Status" : True , "Name" : "Рейтинг игроков в бою"}
            InstallList[1112] := {"Status" : True , "Name" : "Иконки танков по цвету классов техники"}
            InstallList[1113] := {"Status" : False, "Name" : "Статистика за сессию Draug"}
        ;;;;;;;;;; Прицелы ;;;;;;;;;;
        ; !Выбрать только один, иначе будет активирован последний включенный.
            InstallList[121]  := {"Status" : False, "Name" : "Прицел от Draug v.1"}
            InstallList[122]  := {"Status" : False, "Name" : "Прицел от Draug v.1. + сведение Fatality"}
            InstallList[123]  := {"Status" : False, "Name" : "Прицел Taipan"}
            InstallList[124]  := {"Status" : False, "Name" : "Гарпун Lite"}
        ;;;;;;;;;; Счетчик нанесенного урона ;;;;;;;;;;
        ;  !Выбрать только один, иначе будет активирован последний включенный.
            InstallList[131]  := {"Status" : False, "Name" : "Минималистичный лог"}
            InstallList[132]  := {"Status" : False, "Name" : "Подробный лог"}
        ;;;;;;;;;; Еще моды (на любителя) ;;;;;;;;;;
        ; !Если включить установку всего раздела, настроки подраздела будут проигнорированны.
        InstallList[140]  := {"Status" : False, "Name" : "Еще моды (на любителя)"}
            InstallList[141]  := {"Status" : True , "Name" : "Фиксатор прицела"}
            InstallList[142]  := {"Status" : False, "Name" : "Маркер открытой цели"}
            InstallList[143]  := {"Status" : False, "Name" : "Пересадка экипажа"}
            InstallList[144]  := {"Status" : False, "Name" : "Ассист засвета и оглушения"}
            InstallList[145]  := {"Status" : True , "Name" : "Блокировка выстрела по трупам"}
            InstallList[146]  := {"Status" : True , "Name" : "Наблюдатель"}
            InstallList[147]  := {"Status" : True , "Name" : "Улучшить обзор в снайперском режиме"}
            InstallList[148]  := {"Status" : True , "Name" : "Светлячек"}
            InstallList[149]  := {"Status" : False, "Name" : "Шанс на победу"}
            InstallList[1410] := {"Status" : False, "Name" : "Стволик хаоса"}
            InstallList[1411] := {"Status" : True , "Name" : "Уменьшить круг сведения в 2 раза"}
            InstallList[1412] := {"Status" : False, "Name" : "Знак мастера в ушах"}
            InstallList[1413] := {"Status" : True , "Name" : "Отключения тумана"}
        ;;;;;;;;;; Запрещенные ;;;;;;;;;;
        ; !Если включить установку всего раздела, настроки подраздела будут проигнорированны.
        InstallList[150]  := {"Status" : True , "Name" : "Запрещенные"}
            InstallList[151]  := {"Status" : False, "Name" : "Перезарядка противников"}
            InstallList[152]  := {"Status" : False, "Name" : "Снайперский режим для артилерии"}
            InstallList[153]  := {"Status" : False, "Name" : "Попадание без засвета"}
            InstallList[154]  := {"Status" : False, "Name" : "Лазерная указка"}
            InstallList[155]  := {"Status" : False, "Name" : "Целеуказатель"}
            InstallList[156]  := {"Status" : False, "Name" : "Контур - рентген"}
            InstallList[157]  := {"Status" : False, "Name" : "Разрушенные объекты на миникарте"}
            InstallList[158]  := {"Status" : False, "Name" : "Танки вне зоны отрисовки видимости"}
            InstallList[159]  := {"Status" : False, "Name" : "Удаление простреливаемых объектов"}
            InstallList[1510] := {"Status" : False, "Name" : "Незабудка"}                            
            InstallList[1511] := {"Status" : False, "Name" : "Красные шары для артилерии"}
            InstallList[1512] := {"Status" : False, "Name" : "Направление стволов на миникарте"}
            InstallList[1513] := {"Status" : False, "Name" : "Таймер последнего стрелявшего"}
        ;;;;;;;;;; Удаление растительности ;;;;;;;;;;
        ; !Выбрать только один, иначе будет активирован последний включенный.
            InstallList[161]  := {"Status" : False , "Name" : "Тундра"}
            InstallList[162]  := {"Status" : False, "Name" : "BareTrees"}
        ;;;;;;;;;; Автоприцелы / AimBot ;;;;;;;;;;
        ;  !ыбрать только один, иначе будет активирован последний включенный.
            InstallList[171]  := {"Status" : False, "Name" : "Автоприцел с захвато цели за препятствием"}
            InstallList[172]  := {"Status" : False, "Name" : "Аимбот джедай"}
            InstallList[173]  := {"Status" : True , "Name" : "Аимбот шайтан"}

    ;--------------------------------------------------
    ; НАСТРОЙКИ ТЕКСТУРНОГО МОД-ПАКА
    ;--------------------------------------------------
        CheckingVersion_T := False  ; Вкл\выкл установки текстурного мод-пака (True — включено, False — выключено)
        StartLink_T       := "https://draug.ru/dmod/D%20Mod%20Texture%20Mods%20v.1.0.exe"
        FileName_T        := "D Mod Texture Mods"
        ;;;;;;;;;; Моды ;;;;;;;;;;
        ; !Если включить установку всего раздела, настроки подраздела будут проигнорированны.
        InstallList[210]  := {"Status" : True, "Name" : "Моды"}
            InstallList[211]  := {"Status" : False, "Name" : "Шкурки с зонами пробития для танков"}
            InstallList[212]  := {"Status" : False, "Name" : "Цветные декали попаданий"}
            InstallList[213]  := {"Status" : False, "Name" : "Разлет оскольков фугаса"}
            InstallList[214]  := {"Status" : False, "Name" : "Тактическая миникарта позиций"}
            InstallList[215]  := {"Status" : False, "Name" : "Просмотр брони в ангаре"}
        ;;;;;;;;;; Улучшение видимости ;;;;;;;;;;
        ;  !Выбрать только один, иначе будет активирован последний включенный.
            InstallList[221]  := {"Status" : False, "Name" : "Отключение тумана"}
            InstallList[222]  := {"Status" : False, "Name" : "Пасмурная погода"}
            InstallList[223]  := {"Status" : False, "Name" : "Звездное небо"}
        ;;;;;;;;;; Отключение эффектов и улучшение производительности ;;;;;;;;;;
        ; !Если включить установку всего раздела, настроки подраздела будут проигнорированны.
        InstallList[230]  := {"Status" : False, "Name" : "Отключение эффектов и улучшение производительности"}
            InstallList[231]  := {"Status" : True , "Name" : "Дым и пламя от выстрелов"}
            InstallList[232]  := {"Status" : True , "Name" : "Дым и пламя из выхлопных труб"}
            InstallList[233]  := {"Status" : True , "Name" : "Дым от уничтоженных танков"}
            InstallList[234]  := {"Status" : False, "Name" : "Облака"}
            InstallList[235]  := {"Status" : False, "Name" : "Тень под танком"}
            InstallList[236]  := {"Status" : False, "Name" : "Эффекты взрывов снарядов и попадания в объекты"}
            InstallList[237]  := {"Status" : False, "Name" : "Эффекты попадания по танкам"}
            InstallList[238]  := {"Status" : False, "Name" : "Эффекты уничтожения танков"}

    ;--------------------------------------------------
    ; НАСТРОЙКИ ДОПОЛНИТЕЛЬНЫХ МОДОВ
    ;--------------------------------------------------
        InstallAdditionalMods := True   ; Устанавливать дополнительные моды?
        GameFolder  := "F:\Lesta\Tanki"
        ModsFolder  := "F:\Lesta\Tanki_(2)\mods"
        ModsFolder2 := "F:\Lesta\Tanki_(2)\res_mods"

;;;;;;;;;; Variables ;;;;;;;;;;
    LoadIniSection(CheckingFiles("File", True, "SavedSettings.ini"), SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1))
    gDLL := CheckingFiles("File", False, "WorldOfTanks_Images.dll")
    LastWorkingLink_M := LastWorkingLink_M ? LastWorkingLink_M : StartLink_M
    LastWorkingLink_T := LastWorkingLink_T ? LastWorkingLink_T : StartLink_T

;;;;;;;;;; Hotkeys ;;;;;;;;;;
    Hotkey, *%SuspendKey%, Off
    ;Hotkey, *%ReloadScriptKey%, Off
    ;Hotkey, *%StopScriptKey%, Off   

;;;;;;;;;; Gui ;;;;;;;;;;
    PlaceForTheText := "Text text text text text text text text text text text text"
    ;--------------------------------------------------
    UpdateDGP({"Transparency" : gTransparency, "Blur" : gBlur, "FontSize" : 25, "BorderColor" : "ff5100", "BorderSize" : 2})
    GuiInGame("Start", "MainInterface")
        Gui, MainInterface: Add, Text, xm ym +Center cYellow vT1, %PlaceForTheText%
        GuiControl, MainInterface: Text, T1, World of tanks - Mod manager
        Gui, MainInterface: Add, Text, xm y+m +Center vStatusGUI, %PlaceForTheText%
        GuiControl, MainInterface: Text, StatusGUI,
    GuiInGame("End", "MainInterface", {"pos" : ["center", (A_ScreenHeight / 5)]})
    fSuspendGui("On", "MainInterface")
    if DebugGui
        fDebugGui("Create", MainInterface)
    if HideTheInterface
        SetTimer, ShowHideGui , 250, -1
;;;;;;;;;; Start ;;;;;;;;;;
    Main()
        ;ModifyConfigFile("F:\Lesta\Tanki\mods\configs\DMod\mod_ratingPlayersInBattle.json"
        ;, ["""x"": 40,", """x"": 80,"
        ;, """x"": -60,", """x"": -20,"]*)
        ModifyConfigFile("F:\Lesta\Tanki\mods\configs\DMod\mod_ratingPlayersInBattle.json"
        , ["""x"": 40,", """x"": -15,"
        , """x"": -60,", """x"": 5,"]*)
    ModifyConfigFile("F:\Lesta\Tanki\mods\configs\DMod\ReLoad.xml"
    , "<alliesEnable>False</alliesEnable>", "<alliesEnable>True</alliesEnable>"
    , "<startAlliesEnable>False</startAlliesEnable>", "<startAlliesEnable>True</startAlliesEnable>"
    , "<ppReload_x>0</ppReload_x>", "<ppReload_x>5</ppReload_x>"
    , "<ppSPGOnly>True</ppSPGOnly>", "<ppSPGOnly>False</ppSPGOnly>")
    ;ModifyConfigFile("F:\Lesta\Tanki\mods\configs\DMod\RedBalls\mod_redballs.xml"
    ;, "<trajectTime>5.0</trajectTime>", "<trajectTime>15.0</trajectTime>")
    ;ModifyConfigFile("F:\Lesta\Tanki\mods\configs\AimBotShaytan\AimBotShaytan.json"
    ;, ["""showFastMarker"": false,", """showFastMarker"": true,"])
ExitApp

;;;;;;;;;; Scripts ;;;;;;;;;;
    Main() {
        global
        local tempLink, updateFound := False
        local A_Loop, A_key

        ; Проверка новых версии и обновление файлов
        for A_Loop, A_key in ["_M", "_T"] {
            tempLink := false
            if CheckingVersion%A_key% {
                GuiInGame("Edit", "MainInterface", {"id" : "StatusGUI", "Text" : "Проверка файла: " FileName%A_key%})
                tempLink := CheckAndUpdateLink(LastWorkingLink%A_key%)
                if  (tempLink && (tempLink != "NotUpdated")) {
                    updateFound := True
                    GuiInGame("Edit", "MainInterface", {"id" : "StatusGUI", "Text" : "Загрузка нового файла: " FileName%A_key%})
                    LastWorkingLink%A_key% := tempLink
                    CheckAndDownload(LastWorkingLink%A_key%, FileName%A_key%, DownloadFolder) 
                }
            }
        }
        if !updateFound {
            MsgBox, 36, World of tanks - Mod manager, Новых версий не найдено.`nПереустановить моды?
            IfMsgBox, No
                ExitApp
        }
        
        ; Установка модов
        if CheckingVersion_M {
            GuiInGame("Edit", "MainInterface", {"id" : "StatusGUI", "Text" : "Установка модов"})
            RegExMatch(LastWorkingLink_M, "v\.(\d+\.\d+)", VersionMatch)
            LinkVersion := VersionMatch1
            runFile := DownloadFolder . "\" . FileName_M . " v." . LinkVersion . ".exe"
            Run, %runFile%
            Loop
                lSleep(250)
            Until Search("OK", 5, 20)
            ; Меню
            for A_Loop, A_key in ["OK", "Misic", "Next", "Accept", "Next", "Next", "Next"]
                SearchAndClick(A_key, false), lSleep((A_Loop = 1) ? 500 : 25)
            ; Разрешенные
            if InstallList[110].Status
                SearchAndClick(110, false)
            else
                for A_Loop, A_key in [111,112,113,114,115,116,117,118,119,1110,1111,1112,1113]
                    if InstallList[A_key].Status
                        SearchAndClick(A_key, True)
            ; Прицелы / Счетчик нанесенного урона
            for A_Loop, A_key in [121,122,123,124,131,132]
                if InstallList[A_key].Status
                    SearchAndClick(A_key, True)
            ; Еще моды
            if InstallList[140].Status
                SearchAndClick(140, True)
            else
                for A_Loop, A_key in [141,142,143,144,145,146,147,148,149,1410,1411,1412,1413]
                    if InstallList[A_key].Status
                        SearchAndClick(A_key, True)
            ; Запрещенные
            if InstallList[150].Status
                SearchAndClick(150, True)
            else
                for A_Loop, A_key in [151,152,153,154,155,156,157,158,159,1510,1511,1512,1513]
                    if InstallList[A_key].Status
                        SearchAndClick(A_key, True)
            ; Удаление растительности / Автоприцелы
            for A_Loop, A_key in [161,162,171,172,173]
                if InstallList[A_key].Status
                    SearchAndClick(A_key, True)
            ; Завершение
            for A_Loop, A_key in ["Next", "Install"]
                SearchAndClick(A_key, false), lSleep(25)
            Loop
                lSleep(250)
            Until !Search("Cancel", 5, 20)
            for A_Loop, A_key in ["Next", "Info", "Complete"]
                SearchAndClick(A_key, false), lSleep(25)
        }

        ; Установка текстурных модов
        if CheckingVersion_T {
            GuiInGame("Edit", "MainInterface", {"id" : "StatusGUI", "Text" : "Установка текстурных модов"})
            RegExMatch(LastWorkingLink_T, "v\.(\d+\.\d+)", VersionMatch)
            LinkVersion := VersionMatch1
            runFile := DownloadFolder . "\" . FileName_T . " v." . LinkVersion . ".exe"
            Run, %runFile%
            Loop
                lSleep(250)
            Until Search("OK", 5, 20)
            ; Меню
            for A_Loop, A_key in ["OK", "Misic", "Next", "Next"]
                SearchAndClick(A_key, false), lSleep((A_Loop = 1) ? 500 : 25)
            ; Моды
            if InstallList[210].Status
                SearchAndClick(210, True)
            else
                for A_Loop, A_key in [211, 212, 213, 214, 215]
                    if InstallList[A_key].Status
                        SearchAndClick(A_key, True)
            ; Улучшение видимости
            for A_Loop, A_key in [221, 222, 223]
                if InstallList[A_key].Status
                    SearchAndClick(A_key, True)
            ; Отключение эффектов и улучшение производительности
            if InstallList[230].Status
                SearchAndClick(230, True)
            else
                for A_Loop, A_key in [231, 232, 233, 234, 235, 236, 237, 238]
                    if InstallList[A_key].Status
                        SearchAndClick(A_key, True)
            ; Завершение
            for A_Loop, A_key in ["Next", "Install"]
                SearchAndClick(A_key, false), lSleep(25)
            Loop
                lSleep(250)
            Until !Search("Cancel", 5, 20)
            for A_Loop, A_key in ["Info2", "Complete"]
                SearchAndClick(A_key, false), lSleep(25)
        }

        ; Установка дополнительных модов
        if InstallAdditionalMods {
            ; MODS
            GuiInGame("Edit", "MainInterface", {"id" : "StatusGUI", "Text" : "Копирование дополнительных модов"})
            if !FileExist(GameFolder) {
                MsgBox, 16, World of tanks - Mod manager, Не удалось найти папку с игрой по адресу: `n%GameFolder%`nУстановка дополнительных модов будет отменена!
                return
            }
            if !FileExist(ModsFolder) {
                MsgBox, 16, World of tanks - Mod manager, Не удалось найти папку с дополнительными модами по адресу: `n%ModsFolder%`nУстановка дополнительных модов будет отменена!
                return
            }
            GameModsFolder := GameFolder . "\mods"
            
                ; Копируем все из ModsFolder2 в GameModsFolder
                CopyAllMods(ModsFolder, GameModsFolder) 

            ; RES_MODS
            if !FileExist(ModsFolder2) {
                MsgBox, 16, World of tanks - Mod manager, Не удалось найти папку с дополнительными модами по адресу: `n%ModsFolder2%`nУстановка дополнительных модов будет отменена!
                return
            }
            GameModsFolder2 := GameFolder . "\res_mods"
            
                ; Копируем все из ModsFolder2 в GameModsFolder2
                CopyAllMods(ModsFolder2, GameModsFolder2) 
        }
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
            MsgBox, 48, World of tanks - Mod manager, % "Копирование дополнительных модов завершено с ошибками!`n"
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

;;;;;;;;;; Functions ;;;;;;;;;;
    fMouseClick(x, y, t = 25) {
        fSetCursor(x, y)
        lSleep(t)
        fMouseInput("Left")
    }

    ModifyConfigFile(FilePath, param*) {
        ; Функция для изменения настроек в конфиг файлах
        ; param* - пары "найти-заменить": Search1, Replace1, Search2, Replace2, ...

        ; Проверяем четное количество параметров (должны быть пары)
        if (param.Length() & 1) {  ; Проверка на нечетность
            MsgBox, 16, World of tanks - Mod manager, Нечетное количество параметров! Должны быть пары "найти-заменить".
            return false
        }

        ; Проверяем существование файла
        if !FileExist(FilePath) {
            MsgBox, 16, World of tanks - Mod manager, Файл не найден:`n%FilePath%
            return false
        }

        ; Читаем содержимое файла
        FileRead, FileContent, %FilePath%
        if ErrorLevel {
            MsgBox, 16, World of tanks - Mod manager, Ошибка чтения файла:`n%FilePath%
            return false
        }

        NewContent := FileContent

        ; Обрабатываем все пары "найти-заменить"
        Loop, % param.Length() // 2 {
            Index := (A_Index - 1) * 2 + 1
            SearchText := param[Index]
            ReplaceText := param[Index + 1]

            ; Проверяем, существует ли искомая строка
            if !InStr(NewContent, SearchText) {
                ; Сообщаем только если текст не найден
                MsgBox, 48, World of tanks - Mod manager, Текст для замены не найден в файле:`n%FilePath%`n`nИскомый текст:`n%SearchText%
                return false
            }

            ; Заменяем только первое вхождение
            Pos := InStr(NewContent, SearchText)
            if (Pos > 0) {
                Before := SubStr(NewContent, 1, Pos - 1)
                After := SubStr(NewContent, Pos + StrLen(SearchText))
                NewContent := Before . ReplaceText . After
            }
        }

        ; Если ничего не изменилось
        if (NewContent = FileContent) 
            return false

        ; Записываем измененное содержимое
        FileDelete, %FilePath%
        FileAppend, %NewContent%, %FilePath%
        if ErrorLevel {
            MsgBox, 16, World of tanks - Mod manager, Ошибка записи файла:`n%FilePath%
            return false
        }

        ; Успешно завершено
        return true
    }

;;;;;;;;;; Installation ;;;;;;;;;;
    Search(nameKey, repeat = 1, tPause = 25) {
        global
        local coords := [A_ScreenWidth / 4, A_ScreenHeight / 4, (A_ScreenWidth / 4) * 3, (A_ScreenHeight / 4) * 3]
        fSetCursor(gScreenCenter[1], gScreenCenter[2])
        lSleep(25)
        Loop, %repeat% {
            ImageSearch,,, coords[1], coords[2], coords[3], coords[4], % " *" A_Image " HBITMAP:" ReadImages(gDLL, nameKey)
            if !ErrorLevel
                Return true 
            if repeat > 1
                lSleep(tPause)
        }
        Return false
    }

    SearchAndClick(nameKey, scroll) {
        global
        local detected_X, detected_Y, imageSize
        local coords := [A_ScreenWidth / 4, A_ScreenHeight / 4, (A_ScreenWidth / 4) * 3, (A_ScreenHeight / 4) * 3]
        fSetCursor(gScreenCenter[1], gScreenCenter[2])
        lSleep(25)
        loop {
            ImageSearch, detected_X, detected_Y, coords[1], coords[2], coords[3], coords[4], % " *" A_Image " HBITMAP:" ReadImages(gDLL, nameKey)
            if !ErrorLevel {
                imageSize :=  GetImageSizeFromDll(gDLL, nameKey)
                fMouseClick(detected_X + (imageSize.width / 2), detected_Y + (imageSize.height / 2))
                Return true
            } else {
                if scroll
                    fMouseInput("WheelDown", 1)
                lSleep(25)
            }
            if (((A_Index > 60) && scroll) || ((A_Index > 10) && !scroll)) {
                MsgBox, 16, World of tanks - Mod manager, % "Не удалось найти клавишу с ключем: " (InstallList[nameKey].name ? InstallList[nameKey].name : nameKey)
                Return false
            }
        }
    }

;;;;;;;;;; Download File ;;;;;;;;;; 
    CheckAndDownload(LastWorkingLink, FileNamePattern, DownloadFolder) {    
        ; Извлекаем версию из ссылки
        RegExMatch(LastWorkingLink, "v\.(\d+\.\d+)", VersionMatch)
        LinkVersion := VersionMatch1

        ; Ищем файлы в папке по шаблону
        FoundCurrentVersion := false
        Loop, Files, % DownloadFolder . "\" . FileNamePattern . " v.*.exe"
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

        ; Если актуальная версия не найдена, скачиваем новую
        if (!FoundCurrentVersion) {
            try {
                Run, %LastWorkingLink%
                ; Ждем завершения скачивания
                if WaitForDownload(DownloadFolder, FileNamePattern, LinkVersion, gTimeout)
                    return true
            }
            catch {
                MsgBox, 16, World of tanks - Mod manager, Ошибка при открытии ссылки для скачивания
                return false
            }
        }
        return false
    }

    WaitForDownload(DownloadFolder, FileNamePattern, LinkVersion, Timeout = 60) {
        ; Ждем появления файла с нужной версией
        TimeStamp(A_StartDownload)
        Loop {
            Loop, Files, % DownloadFolder . "\" . FileNamePattern . " v.*.exe"
            {
                if (RegExMatch(A_LoopFileName, "v\.(\d+\.\d+)", FileVersionMatch))
                    if (FileVersionMatch1 = LinkVersion)
                        if (!IsFileLocked(A_LoopFileFullPath)) ; Проверяем, не заблокирован ли файл (скачивание завершено)
                            return True
            }
            if (TimePassed(A_StartDownload,, "sec") > Timeout) {
                MsgBox, 16, World of tanks - Mod manager, Превышено время ожидания (%Timeout% сек.) для файла %FileNamePattern% %LinkVersion% `nУстановка будет отменена!
                ExitApp
            }
            lSleep(1000)
        }
    }

    IsFileLocked(Filepath) {
        ; Проверяет, заблокирован ли файл (если да - значит еще скачивается)
        File := FileOpen(Filepath, "r")
        if (File) {
            File.Close()
            return false  ; Файл не заблокирован
        }
        return true  ; Файл заблокирован
    }

;;;;;;;;;; Link ;;;;;;;;;; 
    CheckAndUpdateLink(CurrentLink, maxMajor = 10, maxMinor = 10) {
        ; Функция проверки и поиска версии

        ; Заменяем получение BaseURL и текущей версии
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
                if (CheckLink(NewLink)) {
                    if (NewLink = CurrentLink)
                        Return "NotUpdated"
                    Else
                        Return NewLink
                }
                    
            }
        }
        return ""  ; Не нашли новую версию
    }

    CheckLink(URL) {
        ; Функция проверки доступности ссылки
        try {
            ; Создаем HTTP запрос
            whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
            whr.Open("HEAD", URL, true)
            whr.Send()
            whr.WaitForResponse()

            ; Проверяем статус ответа (200 = OK)
            if (whr.Status = 200)
                return true
            else
                return false
        }
        catch {
            MsgBox, 16, World of tanks - Mod manager, Не удалось проверить ссылку %URL%
            return false
        }
    }

;;;;;;;;;; Exit ;;;;;;;;;;
    BeforeExiting() {
        global
        IniWrite, %LastWorkingLink_M%, %OP_SavedSettings%, % SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1), LastWorkingLink_M
        IniWrite, %LastWorkingLink_T%, %OP_SavedSettings%, % SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".", , -1) - 1), LastWorkingLink_T
    }