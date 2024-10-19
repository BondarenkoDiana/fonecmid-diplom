
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьГрафик(ДатаНачала, ДатаОкончания, ВыходныеДни, ГрафикРаботы) Экспорт
	
	Набор = РегистрыСведений.ВКМ_ГрафикиРаботы.СоздатьНаборЗаписей();
	Набор.Отбор.ГрафикРаботы.Установить(ГрафикРаботы);
	
	Набор.Прочитать();
	
	ЧислоСекундВСутках = 86400;
	
	ДатаНач = ДатаНачала;
	Для Сч = 0 По Набор.Количество()-1 Цикл
		
		Запись = Набор[Сч];
		Если Запись.Дата < ДатаНачала Тогда
			Продолжить;
		ИначеЕсли Запись.Дата =ДатаНач Тогда
			Если СтрНайти(ВыходныеДни, Строка(ДеньНедели(ДатаНач))) Тогда
				Запись.РабочихДней = 0;
			Иначе
				Запись.РабочихДней = 1;
			КонецЕсли;
			ДатаНач = ДатаНач + ЧислоСекундВСутках;
		Иначе
			Пока ДатаНач < Мин(Запись.Дата, ДатаОкончания) Цикл
				НоваяЗапись = Набор.Добавить();
				НоваяЗапись.ГрафикРаботы = ГрафикРаботы;
				НоваяЗапись.Дата = ДатаНач;
				Если СтрНайти(ВыходныеДни, Строка(ДеньНедели(ДатаНач))) Тогда
					НоваяЗапись.РабочихДней = 0;
				Иначе
					НоваяЗапись.РабочихДней = 1;
				КонецЕсли;
				ДатаНач = ДатаНач + ЧислоСекундВСутках;
			КонецЦикла;
			Если Запись.Дата > ДатаОкончания Тогда
				Прервать;
			Иначе
				Если СтрНайти(ВыходныеДни, Строка(ДеньНедели(ДатаНач))) Тогда
					Запись.РабочихДней = 0;
				Иначе
					Запись.РабочихДней = 1;
				КонецЕсли;
			КонецЕсли;
			ДатаНач = ДатаНач + ЧислоСекундВСутках;
		КонецЕсли;
	КонецЦикла;
	Набор.Записать();
	
	Пока ДатаНач <= ДатаОкончания Цикл
		Запись = Набор.Добавить();
		Запись.ГрафикРаботы = ГрафикРаботы;
		Запись.Дата = ДатаНач;
		Если СтрНайти(ВыходныеДни, Строка(ДеньНедели(ДатаНач))) Тогда
			Запись.РабочихДней = 0;
		Иначе
			Запись.РабочихДней = 1;
		КонецЕсли;
		ДатаНач = ДатаНач + ЧислоСекундВСутках;
	КонецЦикла; 
	Набор.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
