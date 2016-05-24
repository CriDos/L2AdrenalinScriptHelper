unit L2Script;

interface

uses
  Classes, SysUtils;

type
  TL2Script = class // Класс скриптов, доступен по имени Script
  public
    // Остановка выполнения скрипта
    procedure Stop;
    // Приостановка выполнения скрипта
    procedure Pause;
    // Приостановка всех потоков, кроме текущего
    procedure Suspend;
    // Восстановление работы всех потоков
    procedure Resume;
    // Создание нового потока
    procedure NewThread(Address: Pointer);
    // Перезапуск текущего скрипта или запуск нового
    function Replace(const Name: string = ''): boolean;
    // Путь к файлу скрипта
    function Path: string;
    // Вызов процедуры в основном потоке программы
    procedure MainProc(Proc: Pointer);
    // Запуск плагина
    function StartPlugin(const PluginName: string; PProc: Pointer; ShowModal: boolean): boolean;

    function OnPluginProc(Code: cardinal; p1: WideString): integer;
  end;
