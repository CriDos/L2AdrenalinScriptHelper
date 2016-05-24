unit L2Npc;

interface

uses
  Classes, SysUtils, L2Live;

type
  TL2Npc = class(TL2Live) // Класс NPC
  public
    // Является объект петом или нет
    function IsPet: boolean;
    // Тип пета (самон или пет)
    function PetType: cardinal;
  end;

implementation

begin
end.
