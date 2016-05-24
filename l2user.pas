unit L2User;

interface

uses
  Classes, SysUtils, L2Char;

type
  TL2User = class(TL2Char) // Класс нашего персонажа
  public
    // Может кристализовать предметы наш герой или нет?
    function CanCryst: boolean;
    // Количество зарядок (для гладов \ тирантов)
    function Charges: cardinal;
    // Штраф от перевеса
    function WeightPenalty: cardinal;
    // Штраф за ношение оружия неподходящего грейда
    function WeapPenalty: cardinal;
    // Штраф за ношение брони неподходящего грейда
    function ArmorPenalty: cardinal;
    // Штраф за смерть
    function DeathPenalty: cardinal;
    // Количество душ (для камаэлей)
    function Souls: cardinal;
  end;

implementation

begin
end.
