unit L2Drop;

interface

uses
  Classes, SysUtils, L2Spawn;

type
  TL2Drop = class(TL2Spawn) // Класс выпадающего с мобов дропа
  public
    // Количество итемов в одной "кучке"
    function Count: int64;
    // Дроп принадлежит нам или нет ("Нам" - если выбил наш чар, пет или члены пати)
    function IsMy: boolean;
    // Стопковый предмет или не может стакаться
    function Stackable: boolean;
  end;

implementation

begin
end.
