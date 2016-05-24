unit L2Skill;

interface

uses
  Classes, SysUtils, L2Effect;

type
  TL2Skill = class(TL2Effect) // Класс игровых умений
  public
    // Доступен ли скил
    function Disabled: boolean;
    // Проточен ли скил
    function Enchanted: boolean;
    // Пассивный скил или нет
    function Passive: boolean;
  end;

implementation

begin
end.
