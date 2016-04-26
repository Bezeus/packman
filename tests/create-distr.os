#Использовать asserts
#Использовать "../src"

Функция ПолучитьСписокТестов(Тестирование) Экспорт
    
    Список = Новый Массив;
    Список.Добавить("Тест_ДолженПроверитьЧтоПараметрыКомСтрокиПолученияВерсииРазобраны");
    Список.Добавить("Тест_ДолженПроверитьЧтоВерсияПолученаИзХранилища");
    Список.Добавить("Тест_ДолженПроверитьЧтоСозданыФайлыКонфигурацииПоставщика");
    
    Возврат Список;
    
КонецФункции

Процедура ПослеЗапускаТеста() Экспорт
    ВременныеФайлы.Удалить();
КонецПроцедуры

Процедура Тест_ДолженПроверитьЧтоПараметрыКомСтрокиПолученияВерсииРазобраны() Экспорт
    
    ПараметрыКомСтроки = Новый Соответствие;
    ПараметрыКомСтроки["АдресХранилища"] = "/some/path/storage";
    ПараметрыКомСтроки["КаталогСборки"] = "/some/path/buildRoot";
    ПараметрыКомСтроки["ВерсияКонфигурации"] = "1.0.4.1";
    ПараметрыКомСтроки["-storage-user"] = "Администратор";
    ПараметрыКомСтроки["-storage-pwd"]  = "123";
    ПараметрыКомСтроки["-storage-v"]    = "4";
    ПараметрыКомСтроки["-cfu-basedir"]  = "/some/path/basedir";
    ПараметрыКомСтроки["-update-from"]  = "1.0.2.1, 1.0.3.7";
    ПараметрыКомСтроки["ФайлМанифеста"]  = "/some/path/outputdir";
    ПараметрыКомСтроки["-setup"]  = Истина;
    ПараметрыКомСтроки["-files"]  = Истина;
    
    Команда = Новый КомандаСобратьИзХранилища;
    
    Параметры = Команда.РазобратьПараметры(ПараметрыКомСтроки);
    
    Ожидаем.Что(Параметры.АдресХранилища).Равно("/some/path/storage");
    Ожидаем.Что(Параметры.КаталогСборки).Равно("/some/path/buildRoot");
    Ожидаем.Что(Параметры.ВерсияКонфигурации).Равно("1.0.4.1");
    Ожидаем.Что(Параметры.ПользовательХранилища).Равно("Администратор");
    Ожидаем.Что(Параметры.ПарольХранилища).Равно("123");
    Ожидаем.Что(Параметры.ВерсияХранилища).Равно("4");
    Ожидаем.Что(Параметры.КаталогВерсий).Равно("/some/path/basedir");
    Ожидаем.Что(Параметры.ПредыдущиеВерсии).ИмеетТип("Массив");
    Ожидаем.Что(Параметры.ПредыдущиеВерсии[0]).Равно("1.0.2.1");
    Ожидаем.Что(Параметры.ПредыдущиеВерсии[1]).Равно("1.0.3.7");
    Ожидаем.Что(Параметры.СобиратьИнсталлятор).ЕстьИстина();
    Ожидаем.Что(Параметры.СобиратьФайлыПоставки).ЕстьИстина();
    Ожидаем.Что(Параметры.ФайлМанифеста).Равно("/some/path/outputdir");
    
КонецПроцедуры

Процедура Тест_ДолженПроверитьЧтоВерсияПолученаИзХранилища() Экспорт
    
    Команда = Новый КомандаСобратьИзХранилища();
    
    ВремКаталогХранилища = СоздатьВременноеТестовоеХранилище();
    ВремФайлКонфигурации = ПолучитьИмяВременногоФайла("cf");
    Попытка
        Команда.ВыгрузитьВерсиюИзХранилища(ВремКаталогХранилища, 2, ВремФайлКонфигурации, "Администратор");
        ФайлТест = Новый Файл(ВремФайлКонфигурации);
        Ожидаем.Что(ФайлТест.Существует(), "файл конфигурации должен существовать"); 
    Исключение
        УдалитьФайлы(ВремКаталогХранилища);
        УдалитьФайлы(ВремФайлКонфигурации);
        ВызватьИсключение;
    КонецПопытки;
    
    УдалитьФайлы(ВремКаталогХранилища);
    УдалитьФайлы(ВремФайлКонфигурации);
    
КонецПроцедуры // Тест_ДолженПроверитьЧтоВерсияПолученаИзХранилища()

Функция СоздатьВременноеТестовоеХранилище() Экспорт
    ФайлХранилища = ТекущийСценарий().Каталог + "/fixtures/storage.1CD";
    ВремКаталогХранилища = ПолучитьИмяВременногоФайла();
    СоздатьКаталог(ВремКаталогХранилища);
    КопироватьФайл(ФайлХранилища, ВремКаталогХранилища + "/1cv8ddb.1CD");
    
    Возврат ВремКаталогХранилища;
КонецФункции

Процедура Тест_ДолженПроверитьЧтоСозданыФайлыКонфигурацииПоставщика() Экспорт
    
    ВременноеХранилище = СоздатьВременноеТестовоеХранилище();
    КаталогСборки = ВременныеФайлы.СоздатьКаталог();
    Параметры = Новый Структура;
    Параметры.Вставить("АдресХранилища", ВременноеХранилище);
    Параметры.Вставить("КаталогСборки", КаталогСборки);
    Параметры.Вставить("ПользовательХранилища","Администратор");
    Параметры.Вставить("ПарольХранилища", "");
    Параметры.Вставить("ВерсияХранилища", "18");
    Параметры.Вставить("КаталогВерсий", ТекущийКаталог()+"__-__");
    Параметры.Вставить("ПредыдущиеВерсии", Новый Массив);
    
    Команда = Новый КомандаСобратьИзХранилища;
    УправлениеКонфигуратором = Новый УправлениеКонфигуратором;
    УправлениеКонфигуратором.КаталогСборки(КаталогСборки);
    
    ВерсияИзХранилища = ПолучитьИмяВременногоФайла("cf");
    Команда.ВыгрузитьВерсиюИзХранилища(Параметры.АдресХранилища, 18, ВерсияИзХранилища, "Администратор");
    Команда.ЗагрузитьКонфигурациюВБазуСборки(УправлениеКонфигуратором, ВерсияИзХранилища);
    Команда.СоздатьФайлыКонфигурацииПоставщика(УправлениеКонфигуратором, Параметры);
    
    ФайлКонфигурации = Новый Файл(ОбъединитьПути(КаталогСборки, "1Cv8.cf"));
    Ожидаем.Что(ФайлКонфигурации.Существует(), "Файл конфигурации должен существовать");
    
КонецПроцедуры