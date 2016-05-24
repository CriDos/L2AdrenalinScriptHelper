unit Gps;

interface

uses
  Classes, SysUtils;

type
  TGps = class // Класс навигации персонажа
  public
    // Общее количество точек
    function Count: integer;
    // Загрузка базы Gps, возвращает кол-во загруженных точек
    function LoadBase(const FilePath: string): integer;
    // Прокладывает маршрут от точки (X1, Y1, Z1) до (X2, Y2, Z2) и записывает точки этого маршрута в GPS.ItemsВозвращает длину проложенного маршрута
    function GetPath(X1, Y1, Z1, X2, Y2, Z2: single): integer;
    // Прокладывает маршрут до точки по ее названию и записывает точки этого маршрута в GPS.Items Возвращает длину проложенного маршрута
    function GetPathByName(X1, Y1, Z1: single; PointName: string): integer;
    // Возвращает точку с указанным индексом
    function Items(Index: integer): TGpsPoint;
  end;

implementation

begin
end.
