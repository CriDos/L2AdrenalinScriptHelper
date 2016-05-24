unit L2Char;

interface

uses
  Classes, SysUtils, L2Live, Global;

type
  TL2Char = class(TL2Live) // Класс всех игроков
  public
    // CP в процентах
    function CP: cardinal;
    // Точное значение CP
    function CurCP: cardinal;
    // Максимальное значение CP
    function MaxCP: cardinal;
    // Игрок является героем или нет?
    function Hero: boolean;
    // Игрок является дворянином или нет?
    function Noble: boolean;
    // Идентификатор класса игрока, информацию об этих значениях можно узнать на форуме
    function ClassID: cardinal;
    // Идентификатор основного класса
    function MainClass: cardinal;
    // Тип ездового животного
    function MountType: byte;
    // Тип личной лавки
    function StoreType: byte;
    // Пол игрока(0: мужской, 1: женский)
    function Sex: cardinal;
    // Раса игрока (0 - human, 1: elf, 2: dark elf, 3: orc, 4: dwarf, 5: kamael)
    function Race: cardinal;
    // Кол-во призванных кубиков
    function CubicCount: cardinal;
    // Кол-во рекомендаций игрока
    function Recom: cardinal;
    // Активен ли премиум аккаунт у игрока?
    function Premium: boolean;
    // Тип игрового объекта
    function L2Class: TL2Class; override;

    property BaseClass: TBaseClass read GetClassInfo;

    property Crest: TL2Crest read GetCrest;

    property L2Clan: TL2Clan read GetClan;
  end;

implementation

begin
end.

