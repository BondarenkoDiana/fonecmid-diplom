﻿#language: ru

@tree
@ExportScenarios
@ТипШага: Нетология. Работа с отчетами
@Описание: Запускает отчет Анализ выставленных актов, сравнивает с эталоном
@ПримерИспользования: И я проверяю формирование отчета Анализ выставленных актов

Функционал: Проверка формирования отчета Анализ выставленных актов 

Как тестировщик я хочу
проверить формирование отчета Анализ выставленных актов и сравнение с эталоном
чтобы сократить время на ручное регрессионное тестирование  

Контекст:
		Я запускаю сценарий открытия TestClient или подключаю уже существующий

Сценарий: Я проверяю формирование отчета Анализ выставленных актов
	* Я открываю отчет Анализ выставленных актов 
		И В командном интерфейсе я выбираю 'Обслуживание клиентов' 'Анализ выставленных актов'
		Тогда открылось окно 'Анализ выставленных актов'
	* Я выбираю период отчета	
		И я нажимаю кнопку выбора у поля с именем "КомпоновщикНастроекПользовательскиеНастройкиЭлемент0Значение"
		Тогда открылось окно 'Выберите период'
		И в поле с именем 'DateBegin' я ввожу текст '01.09.2024'
		И в поле с именем 'DateEnd' я ввожу текст '30.09.2024'
		И я нажимаю на кнопку с именем 'Select'
		Тогда открылось окно 'Анализ выставленных актов'
	* Я формирую отчет	
		И я нажимаю на кнопку с именем 'СформироватьОтчет'
	* Я сравниваю начисленные и выставленные суммы по контрагенту и договору
		И я запоминаю значение ячейки табличного документа 'ОтчетТабличныйДокумент' "R2C3" в переменную "Эталон"
		И в табличном документе 'ОтчетТабличныйДокумент' ячейка с адресом "R2C4" равна "$Эталон$"
	И я закрываю TestClient "Бухгалтер ИТ Фирмы"	


		
				
			


