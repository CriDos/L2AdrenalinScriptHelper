unit L2Live;

interface

uses
  Classes, SysUtils, L2Spawn, L2List, L2Cast, Global;

type
  TL2Live = class(TL2Spawn) // Класс живых объектов в игре (игроки, NPC, петы и тд)
  public
    // Текущее кол-во HP в процентах
    function HP: cardinal;
    // Точное зачение HP
    function CurHP: cardinal;
    // Максимальное количество HP
    function MaxHP: cardinal;
    // Текущее кол-во MP в процентах
    function MP: cardinal;
    // Точное значение MP
    function CurMP: cardinal;
    // Максимальное количество MP
    function MaxMP: cardinal;
    // Опыт (численное значение)
    function Exp: int64;
    // Опыт (в процентах)
    function Exp2: int64;
    // Очки SP
    function SP: cardinal;
    // Является объект Player Killer'ом или нет
    function PK: boolean;
    // Находится объект в режиме PvP или нет
    function PvP: boolean;
    // Значение кармы (начиная с GoD может быть как отрицательной - PK, так и положительной - репутация)
    function Karma: integer;
    // Загруженность в процентах (доступна для нашего чара или петов)
    function Load: cardinal;
    // Уровень объекта
    function Level: byte;
    // Титул объекта
    function Title: string;
    // Скорость передвижения
    function Speed: double;
    // Объект движется пешком или бегом
    function Running: boolean;
    // Сидит объект или нет
    function Sitting: boolean;
    // Рыбачит объект или нет
    function Fishing: integer;
    // Летит объект или нет
    function Fly: boolean;
    // Жив или мертв объект
    function Dead: boolean;
    // Объект выронил предмет или нет (Dead должен быть True)
    function Dropped: boolean;
    // К объекту можно применять Sweep(Присвоение) или нет? (Dead должен быть True)
    function Sweepable: boolean;
    // Название клана в котором находится объект
    function Clan: string;
    // ID клана в котором находится объект
    function ClanID: cardinal;
    // Название альянса в котором находится объект
    function Ally: string;
    // ID альянса в котором находится объект
    function AllyID: cardinal;
    // Свободно атакуемый объект или нет (без ctrl)
    function Attackable: boolean;
    // Уникальный идентификатор объекта который атакует
    function AtkOID: cardinal;
    // Время, которое объект атакуется
    function AtkTime: cardinal;
    // Время, которое объект атакуется пользователем
    function MyAtkTime: cardinal;
    // Находится объект в бою или нет
    function InCombat: boolean;
    // Список бафов объекта (доступны для нашего чара, пета и сопартийцев)
    function Buffs: TBuffList;
    // Скил который объект кастует в данный момент. Актуально если Cast.EndTime > 0, иначе объект в данный момент не кастует
    function Cast: TL2Cast;
    // Цель объекта
    function Target: TL2Live;
    // Является объект членом нашей группы или нет
    function IsMember: boolean;
    // Для пвп серверов (красное синие подсвечивание), так же мобы "чемпионы"
    function Team: byte;
    // Дистанция последней телепортации объекта
    function TeleportDist: cardinal;
    // Время в мс, прошедшее с момента последней телепортации объекта
    function TeleportTime: cardinal;
    // ID получившийся из наборов флагов
    function AbnormalID: cardinal;
    // Список необычных состояний (для GOD+ хроник)
    function Abnormals: TBuffList;
    // Координата X, куда движется объект
    function ToX: integer;
    // Координата Y, куда движется объект
    function ToY: integer;
    // Координата Z, куда движется объект
    function ToZ: integer;
  end;

implementation

begin
end.
