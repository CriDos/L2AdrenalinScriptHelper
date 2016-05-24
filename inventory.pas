unit Inventory;

interface

uses
  Classes, SysUtils, L2List;

type
  TInventory = class // Класс описывающий наши инвентари
  public
    // Инветарь нашего пета
    function Pet: TItemList;
    // Инветарь нашего персонажа
    function User: TItemList;
    // Инветарь нашего персонажа (квестовый)
    function Quest: TItemList;
  end;

implementation

begin
end.


