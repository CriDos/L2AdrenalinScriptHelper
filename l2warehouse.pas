unit L2WareHouse;

interface

uses
  Classes, SysUtils, L2List, L2Item;

type
  TL2WareHouse = class(TL2List) // Класс описывающий наш склад
  public
    // Тип инвентаря
    property WHType: word;
    // Количество адены на складе
    property Adena: int64;
    // Список предметов на нашем складе
    function Items(Index: integer): TL2Item;
  end;

implementation

begin
end.
