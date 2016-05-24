unit L2Pet;

interface

uses
  Classes, SysUtils, L2Npc;

type
  TL2Pet = class(TL2Npc) // Класс наших петов/самонов
  public
    // Голод питомца (еда) в процентах
    function Fed: cardinal;
  end;
