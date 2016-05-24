unit L2Item;

interface

uses
  Classes, SysUtils, L2Effect;

type
  TL2Item = class(TL2Effect) // Класс игровых предметов
  public
    // Количество предметов (если стопка)
    function Count: int64;
    // Одета на нас вещь или нет
    function Equipped: boolean;
    // Уровень заточки предмета
    function EnchantLevel: word;
    // Тип предмета (0 оружие; 1 броня; 2 бижа; 5 ресурсы и все остальное)
    function ItemType: cardinal;
    // Грейд предмета
    function Grade: cardinal;
    // Название грейда предмета ('NG', 'D', 'C', 'B', 'A', 'S', 'S80', 'S84', 'R', 'R95', 'R99')
    function GradeName: string;
  end;

implementation

begin
end.
