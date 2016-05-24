unit Party;

interface

uses
  Classes, SysUtils, Global, L2List, L2Char;

type
  TParty = class // Класс описывающий нашу группу
  public
    // Список петов в группе
    function Pets: TNpcList;
    // Список чаров в группе
    function Chars: TCharList;
    // Тип распределения лута в группе
    function LootType: TLootType;
    // Лидер группы
    function Leader: TL2Char;
  end;

implementation

begin
end.

