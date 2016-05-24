unit L2AucItem;

interface

uses
  Classes, SysUtils, L2Item;

type
  TL2AucItem = class(TL2Item) // Класс игровых предметов с аукциона
  public
    // Тип лота
    function LotType: cardinal;
    // Ник продавца
    function Seller: string;
    // Цена лота за которую можно выкупить предмет
    function Price: int64;
    // Время, на которое выставлен предмет
    function Days: cardinal;
    // Время до завершения торгов в секундах
    function EndTime: cardinal;
  end;

implementation

begin
end.
