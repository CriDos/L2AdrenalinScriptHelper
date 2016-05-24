unit L2Object;

interface

uses
  Classes, SysUtils, Global;

type
  TL2Object = class // Базовый класс всех игровых объектов
  public
    // ID объекта
    property ID: cardinal;
    // Имя объекта
    property Name: string;
    // Уникальный идентификатор для любого объекта в игре
    property OID: cardinal;
    // Проверка объекта на существование в игре (актуальность)
    property Valid: boolean;
    // Узнать класс к которому относится данный объект
    property L2Class: TL2Class;
    // Назначить объекту пользовательскую переменную
    procedure SetVar(Value: cardinal);
    // Получить значение пользовательской переменной
    function GetVar: cardinal;
  end;

implementation

begin
end.
