/* 
    Функция fConfigEditor(FilePath, param*) предназначена для поиска и замены текста в конфигурационных файлах.

    Параметры:
        FilePath - Полный путь до файла (включая имя и расширение)
        param*   - Чётное количество аргументов в формате: "Что ищем", "На что заменяем"

    Важные моменты:
        - Количество аргументов param* должно быть ЧЁТНЫМ
        - Аргументы работают парами: первый - текст для поиска, второй - текст для замены
        - Можно передать любое количество пар

    Примеры использования:

        fConfigEditor("C:\Lesta\Tanki\mods\configs\settings.ini"
            , "значение 1", "новое значение 1"
            , "значение 2", "новое значение 2")

        fConfigEditor("C:\Lesta\Tanki\mods\configs\mod_config.xml"
            , "<setting1>False</setting1>", "<setting1>True</setting1>"
            , "<setting2>0</setting2>", "<setting2>5</setting2>"
            , "<setting3>Text</setting3>", "<setting3>NewText</setting3>")
*/