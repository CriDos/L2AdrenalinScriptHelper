unit L2Spawn;

interface

uses
  Classes, SysUtils, L2Object;

type
  TL2Spawn = class(TL2Object) // Класс всех объектов имеющих координаты
  public
    // Координата X объекта
    function X: integer;
    // Координата Y объекта
    function Y: integer;
    // Координата Z объекта
    function Z: integer;
    // Дистанция до точки \ объекта
    function DistTo(X: integer; Y: integer; Z: integer): cardinal; overload;   // Возвращает дистанцию до заданной точки
    function DistTo(Obj: TL2Spawn): cardinal; overload;   // Возвращает дистанцию до объекта
    // Время, которое прошло со времени появления объекта в игровом мире (в мс)
    function SpawnTime: cardinal;
    // Проверка объекта в радиусе Range от точки (x, y, z)
    function InRange(X: integer; Y: integer; Z: integer; Range: cardinal; ZRange: cardinal = 250): boolean;
    // Проверка на вхождение объекта в зону охоты
    function InZone: boolean;
  end;

implementation

begin
end.
