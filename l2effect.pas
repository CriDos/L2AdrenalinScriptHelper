unit L2Effect;

interface

uses
  Classes, SysUtils, L2Object;

type
  TL2Effect = class(TL2Object) // Класс игровых эффектов
  public
    // Уровень скила \ бафа
    function Level: cardinal;
    // Время до окончания действия (для эффектов) \ время отката умения (для скилов)
    function EndTime: cardinal;
  end;

implementation

begin
end.
