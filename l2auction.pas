unit L2Auction;

interface

uses
  Classes, SysUtils, L2List, L2AucItem, L2Item;

type
  TL2Auction = class(TL2List) // Класс для работы с аукционом
  public
    // Формирует поисковый запрос. Результат помещается в объект Auction
    function Search(const Name: string; Grade: integer = -1; PageID: integer = 0): boolean;
    // Выставить предмет на продажу
    function SellItem(Item: TL2Item; Count, Price, Days: cardinal; CustomName: string = ''): boolean;
    // Купить предмет с аукциона
    function BuyItem(Item: TL2AucItem): boolean;
    // Получить список своих лотов продажи
    function GetMySales: boolean;
    // Снять предмет с продажи
    function CancelItem(Item: TL2AucItem): boolean;
    // Позволяет обратиться к объекту в списке по индексу
    property Items: TL2AucItem;
  end;

implementation

begin
end.
