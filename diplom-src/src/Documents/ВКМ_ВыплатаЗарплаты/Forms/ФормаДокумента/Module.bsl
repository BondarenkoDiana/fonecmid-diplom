
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Объект.Выплаты.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВКМ_ВзаиморасчетыССотрудникамиОстатки.Сотрудник КАК Сотрудник,
	|	СУММА(ВКМ_ВзаиморасчетыССотрудникамиОстатки.СуммаОстаток) СуммаОстаток
	|ИЗ
	|	РегистрНакопления.ВКМ_ВзаиморасчетыССотрудниками.Остатки КАК ВКМ_ВзаиморасчетыССотрудникамиОстатки
	|СГРУППИРОВАТЬ ПО
	|	ВКМ_ВзаиморасчетыССотрудникамиОстатки.Сотрудник"; 
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Объект.Выплаты.Добавить();
		НоваяСтрока.Сотрудник = Выборка.Сотрудник;
		НоваяСтрока.Сумма = Выборка.СуммаОстаток;
	КонецЦикла;
	
	Если Объект.Выплаты.Количество() = 0 Тогда
		ОбщегоНазначения.СообщитьПользователю("Зарплата выплачена");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
