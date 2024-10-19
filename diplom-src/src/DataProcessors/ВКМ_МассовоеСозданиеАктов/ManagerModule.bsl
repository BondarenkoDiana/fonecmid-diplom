
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Метод получает массив структур, состоящих из договоров контрагентов и документов реализации товаров и услуг
// Параметры:
// Период- Дата
// Возвращаемое значение:
// Массив Из Структура:
//     Договор - СправочникСсылка.ДоговорыКонтрагентов,
//     Реализация - ДокументСсылка.РеализацияТоваровУслуг
Функция ТяжелаяОперация(Период) Экспорт
	
	ТЗ_ДокИДог = ПолучитьДоговорыИРеализации(Период);
	
	МассивДляТЧ = Новый Массив;
	
	Для Каждого СтрокаТЗ Из ТЗ_ДокИДог Цикл 
		
		Если НЕ ЗначениеЗаполнено(СтрокаТЗ.РеализацияТоваровУслуг) Тогда
			
			МассивДляТЧ.Добавить(Новый Структура("Договор, Реализация", СтрокаТЗ.Договор, СоздатьНовыйДокРеализации(СтрокаТЗ, Период)));
			Продолжить;
			
		КонецЕсли;
		
		МассивДляТЧ.Добавить(Новый Структура("Договор, Реализация", СтрокаТЗ.Договор, СтрокаТЗ.РеализацияТоваровУслуг));
		
	КонецЦикла;
	
	Возврат МассивДляТЧ;
	
КонецФункции

// Метод создает новую строку ТЧ обработки и заполняет данными из параметров
// Параметры:
// Договор - СправочникСсылка.ДоговорыКонтрагентов
// Реализация - ДокументСсылка.РеализацияТоваровУслуг
// ТабЧасть - ТабличнаяЧасть
Процедура ДобавитьСтрокуВТЧ(Договор, Реализация, ТабЧасть) Экспорт
	
	НоваяСтрокаТЧ = ТабЧасть.Добавить();
	НоваяСтрокаТЧ.Договоры = Договор;
	НоваяСтрокаТЧ.РеализацияТоваровУслуг = Реализация;
	
КонецПроцедуры

// Метод получает документы реализации и договоры на выбранный период
// Параметры: 
// Период - Дата
// Возвращаемое значение:
// ДокументСсылка.РеализацияТоваровУслуг
Функция ПолучитьДоговорыИРеализации(Период) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ДоговорыКонтрагентов.Ссылка КАК Договоры
	|ПОМЕСТИТЬ вт_Договоры
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|ГДЕ
	|	ДоговорыКонтрагентов.ВКМ_ДатаНачалаДействияДоговора < КОНЕЦПЕРИОДА(&Период, МЕСЯЦ)
	|	И ДоговорыКонтрагентов.ВКМ_ДатаОкончанияДействияДоговора > НАЧАЛОПЕРИОДА(&Период, МЕСЯЦ)
	|	И ДоговорыКонтрагентов.ВидДоговора = &ВидДоговора
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РеализацияТоваровУслуг.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ вт_Реализация
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|ГДЕ
	|	РеализацияТоваровУслуг.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&Период, МЕСЯЦ) И КОНЕЦПЕРИОДА(&Период, МЕСЯЦ)
	|	И РеализацияТоваровУслуг.Договор.ВидДоговора = &ВидДоговора
	|	И НЕ РеализацияТоваровУслуг.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	вт_Договоры.Договоры.Ссылка КАК Договор,
	|	вт_Реализация.Ссылка КАК РеализацияТоваровУслуг
	|ИЗ
	|	вт_Договоры КАК вт_Договоры
	|		ПОЛНОЕ СОЕДИНЕНИЕ вт_Реализация КАК вт_Реализация
	|		ПО вт_Договоры.Договоры.Ссылка = вт_Реализация.Ссылка.Договор";
	
	Запрос.УстановитьПараметр("Период", Период);
	Запрос.УстановитьПараметр("ВидДоговора", Перечисления.ВидыДоговоровКонтрагентов.ВКМ_АбонентскоеОбслуживание);
		
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции

// Создание нового документа Реализации товаров и услуг
// Параметры:
// 	СтрокаТЗ - СтрокаТаблицыЗначений
// 	Период- Дата
// Возвращаемое значение:
// ДокументСсылка.РеализацияТоваровУслуг 
Функция СоздатьНовыйДокРеализации(СтрокаТЗ, Период) Экспорт

	НовыйДок = Документы.РеализацияТоваровУслуг.СоздатьДокумент();
	НовыйДок.Заполнить(Неопределено);
	НовыйДок.Организация = СтрокаТЗ.Договор.Организация;
	НовыйДок.Контрагент = СтрокаТЗ.Договор.Владелец;
	НовыйДок.Договор = СтрокаТЗ.Договор;
	НовыйДок.Дата = Период;
	НовыйДок.Ответственный = Пользователи.ТекущийПользователь();
	НовыйДок.Комментарий = "Этот документ создан групповой обработкой.";
	НовыйДок.ВКМ_ВыполнитьАвтозаполнение();
	
	Если НовыйДок.ПроверитьЗаполнение() Тогда
		НовыйДок.Записать(РежимЗаписиДокумента.Проведение);
	КонецЕсли;
	
	Возврат НовыйДок.Ссылка;

КонецФункции

#КонецОбласти

#КонецЕсли
