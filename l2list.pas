unit L2List;

interface

uses
  Classes, SysUtils, L2Object, L2AucItem, L2Spawn, L2Npc, L2Pet, L2Char,
  L2Drop, L2Skill, L2Buff, L2Item;

type
  TL2List = class // Родительский класс для всех списков в боте
  public
    // Поиск объекта в списке по ID. Если объект найден, он помещается в переменную Obj
    function ByID(ID: cardinal; var Obj): boolean;
    // Поиск объекта в списке по OID. Если объект найден, он помещается в переменную Obj
    function ByOID(OID: cardinal; var Obj): boolean;
    // Поиск объекта в списке по имени. Если объект найден, он помещается в переменную Obj
    function ByName(const Name: string; var Obj): boolean;
    // Количество объектов в списке
    function Count: integer;
    // Позволяет обратиться к объекту в списке по индексу
    function Items(Index: integer): TL2Object;
  end;

  TAuctionList = class(TL2List)
  public
    // Позволяет обратиться к объекту в списке по индексу
    function Items(Index: integer): TL2AucItem; overload;
  end;

  TSpawnList = class(TL2List)
  public
    // Позволяет обратиться к объекту в списке по индексу
    function Items(Index: integer): L2Spawn; overload;
  end;

  TNpcList = class(TL2List)
  public
    // Позволяет обратиться к объекту в списке по индексу
    function Items(Index: integer): TL2Npc; overload;
  end;

  TPetList = class(TL2List)
  public
    // Позволяет обратиться к объекту в списке по индексу
    function Items(Index: integer): TL2Pet; overload;
  end;

  TCharList = class(TL2List)
  public
    // Позволяет обратиться к объекту в списке по индексу
    function Items(Index: integer): TL2Char; overload;
  end;

  TDropList = class(TL2List)
  public
    // Позволяет обратиться к объекту в списке по индексу
    function Items(Index: integer): TL2Drop; overload;
  end;

  TSkillList = class(TL2List)
  public
    // Позволяет обратиться к объекту в списке по индексу
    function Items(Index: integer): TL2Skill; overload;
  end;

  TItemList = class(TL2List)
  public
    // Позволяет обратиться к объекту в списке по индексу
    function Items(Index: integer): TL2Item; overload;
  end;

  TBuffList = class(TL2List)
  public
    // Позволяет обратиться к объекту в списке по индексу
    function Items(Index: integer): TL2Buff; overload;
  end;

implementation

begin
end.
