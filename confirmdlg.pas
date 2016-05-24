unit ConfirmDlg;

interface

uses
  Classes, SysUtils;

type
  TConfirmDlg = class // Класс диалоговых окон с подтверждением
  public
    // Идентификатор системного сообщения
    function MsgID: cardinal;
    // Идентификатор
    function ReqID: cardinal;
    // Ник отправителя запроса
    function Sender: string;
    // Время до исчезновения диалога
    function EndTime: cardinal;
    // Актуален ли диалог?
    function Valid: boolean;
  end;

implementation

begin
end.
