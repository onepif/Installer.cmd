# Скрипт предварительной конфигурации OS Window & установки специаального программного обеспечения (СПО) ЗАО "ПЕЛЕНГ"
## АННОТАЦИЯ
### Данный README описывет технологию работы с конфингурационным скриптом.
Скрипт предусматриваеи установку и настройку следующих устройств: 
+ блоки БРИ из состава изделия «СМАР-Т»;
+ блоки АРМВ из состава изделия «СМАР-Т»;
+ блоки БВЗ из состава изделия «СМАР-Т»;
+ блоки БОИ из состава изделия «Мастер»;
+ блоки БКДИ из состава изделия «АСК-РЛС»;
+ блоки БХС из состава изделия «Тахион»;
+ блоки БОИ из состава изделия КАПС ИС;
+ блоки БОИ из состава изделия Плановый сервер;
+ блоки БС из состава изделия ТДК «Мастер-Т».

## 1. ТРЕБОВАНИЯ К ПЕРВРНАЧАЛЬНОМУ ЗАПУСКУ СКРИПТА
1.1 На поставочном блоке должна быть установлена операционная система MS Windows.

## 2. РАБОТА СО СКРИПТОМ
2.1 После загрузки ОС при помощи проводника зайти на съемный диск в папку «X:\setup» и запустить файл «run.cmd». Этот исполняемый файл запустит от имени администратора файл «main.cmd» и передаст ему все параметры с которыми был запущен сам. Допускается запустить файл «main.cmd» непосредственно из пвпки  «X:\setup\script», но тогда, если он был запущен не с правами администратора работа будет прервана с соответствующим сообщением.
2.2 Выбрать тип поставочного изделия из списка, нажав для этого соответствующую цифру:
  1. изделие СМАР‑Т;
  1. изделие Мастер;
  1. изделие АСК-РЛС;
  1. изделие Тахион;
  1. изделие КАПС ИС;
  1. изделие Плановый сервер;
  1. изделие ТДК «Мастер-Т».

Далее необходимо указать какой блок будет конфигурироваться. Например, при конфигурировании блока для изделия «Мастер» вводится цифра от 1 до 3.
2.5 По завершении выполнения будет выполнена перезагрузка.
2.6 После загрузки ОС MS Windows, при помощи проводника, зайти на съемный диск в папку «Script» и повторно запустить файл «main.cmd» от имени администратора.
2.7 По окончании успешного выполнения будет выполнена повторная  перезагрузка.
2.8 Настройка завершена.

> Использование: main.cmd [args]

> [args] могут принимать следующие значения:

> -D [1^|..] : включить отладочный режим. Будет производится вывод дополнительной информации;

> -O [path\to\file.ext]: включить режим вывода информации в файл [по умолчанию - %PROGRAMDATA%\logfiles\install.log];

> -S on^|off  : если задан явно, то однозначно определяет режим вывода информации в консоль; если не задан, то вывод в консоль будет отключён при параметрах -E или -G [по умолчанию включён];
> -In : установить номер изделия, где n:
>	1 - СМАР-Т
	echo           2 - Мастер
	echo           3 - АСК
	echo           4 - Тахион
	echo           5 - Информационный сервер
	echo           6 - Плановый сервер
	echo           7 - ТДК [Блок Связи]
	echo -Bn : установить номер блока [1, 2, и т.д];
	echo -G  : разрешить графический интерфейс [GUI]. По умолчанию выбран режим командной строки [CLI];
	echo -C  : сбросить все заданные ранее настройки [флаги] и выполнить скрипт с запросом всех параметров;
	echo -F path\to\file.ext : использовать file.ext для конфигурирования процесса установки,если не задан,
	echo					   то ищется файл с именем main.xml;
	echo -Y  : отвечать 'ДА' на все вопросы ['тихий' режим];
	echo -H  : эта справочная информация.
	echo.
	echo Пример:
	echo	main.cmd -i2 -b1 -y - будет выполнена 'тихая' установка СПО 'Мастер' на ПК с назначением ему имени 'BOI-1'
