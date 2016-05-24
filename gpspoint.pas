unit GpsPoint;

interface

uses
  Classes, SysUtils;

type
  TGpsPoint = class // Класс точек GPS баз
  public
    // Координата X
    property X: integer;
    // Координата Y
    property Z: integer;
    // Координата Z
    property Name: string;
  end;

implementation

begin
end.
