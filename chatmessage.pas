unit ChatMessage;

interface

uses
  Classes, SysUtils, Global;

type
  TChatMessage = class // Класс внутриигровых сообщений
  public
    // Сообщение не прочитано нами?
    property Unread: boolean;
    // Ник отправителя
    property Sender: string;
    // Текст сообщения
    property Text: string;
    // Тип сообщения
    property ChatType: TMessageType;
  end;

implementation

begin
end.
