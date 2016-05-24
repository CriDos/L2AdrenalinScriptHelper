unit L2Control;

interface

uses
  Classes, SysUtils, Global, L2Spawn,
  L2AucItem, L2AucItem, L2Item, L2Live, L2Drop,
  L2Npc, ConfirmDlg, L2List, Inventory, Party,
  L2User;

type
  TL2Control = class // Класс управления игровыми действиями, доступен по имени Engine. Можно управлять другим окном с помощью GetControl
  public
    // Двигаться в указанную точку \ к указанному объекту
    function MoveTo(X, Y, Z: integer; const TimeOut: integer = 8000): boolean; overload;   // Двигаться в точку
    function MoveTo(Obj: TL2Spawn; Dist: integer): boolean; overload;   // Подойти к объекту
    // Двигаться в указанную точку без ожидания результата
    function DMoveTo(x, y, z: integer): boolean;
    // Подойти к выбранной цели на указанную дистанцию
    function MoveToTarget(Dist: integer = -100): boolean;
    // Купить предмет с аукциона
    function AuctionBuyItem(Item: TL2AucItem): boolean;
    // Снять предмет с продажи
    function AuctionCancelItem(Item: TL2AucItem): boolean;
    // Получить список своих лотов продажи
    function AuctionGetMySales: boolean;
    // Формирует поисковый запрос. Результат помещается в объект Auction
    function AuctionSearch(const Name: string; Grade: integer = -1; PageID: integer = 0): boolean;
    // Выставить предмет на продажу
    function AuctionSellItem(Item: TL2Item; Count, Price, Days: cardinal; CustomName: string = ''): boolean;
    // Делает своей целью цель указанного игрока или NPC
    function Assist(const Name: string): boolean;
    // Атака
    function Attack(TimeOut: cardinal = 2000; Ctrl: boolean = False): boolean;
    // Включает/выключает автоматическое использование сосок (зарядов души\духа)
    function AutoSoulShot(const Name: string; Active: boolean): boolean;
    // Авто-подбор цели
    function AutoTarget(Range: cardinal = 2000; ZRange: cardinal = 300; NotBusy: boolean = True): boolean;
    // Поиск "врага" для заданного объекта в указанном радиусе (относительно объекта). Найденный "враг" будет записан в переменную Enemy.
    function FindEnemy(var Enemy: TL2Live; Obj: TL2Live; Range: cardinal = 2000; ZRange: cardinal = 300): boolean;
    // Взять в таргет
    function SetTarget(const Name: string): boolean; overload;   // Взять в таргет по имени
    function SetTarget(ID: cardinal): boolean; overload;   // Взять в таргет по ID
    function SetTarget(Obj: TL2Live): boolean; overload;   // Взять в таргет объект Obj
    // Сбрасывает таргет
    function CancelTarget: boolean;
    // Подбор дропа
    // Подобирает указанный объект
    function PickUp(Obj: TL2Drop; Pet: boolean = False): boolean; overload;
    // Авто-подбор всего дропа в указанном радиусе
    function PickUp(Range: cardinal = 250; ZRange: cardinal = 150; OnlyMy: boolean = False; Pet: boolean = False): integer; overload;
    // Включить / отключить интерфеис
    function FaceControl(ID: integer; Active: boolean): boolean;
    // Загрузка конфига с указанным именем. По умолчанию из папки Settings, но можно указать полный путь.
    function LoadConfig(const Name: string): boolean;
    // Загрузка боевой зоны из файла
    function LoadZone(const Name: string): boolean;
    // Очистка всех зон на карте
    procedure ClearZone;
    // Добавляет объект в список игнгора. Методы AutoTarget и AutoPickup пропускают такие объекты
    procedure Ignore(Obj: TL2Spawn);
    // Очищает список игнора
    procedure ClearIgnore;
    // Проверяет, находится ли объект\точка в заданной зоне
    function InZone(Obj: TL2Spawn): boolean; overload;   // Объект находится в зоне?
    function InZone(X, Y, Z: integer): boolean; overload;   // Точка находится в зоне?
    // Мигает окном на панели задач
    function BlinkWindow(GameWindow: boolean): boolean;
    // Получить HWND окна с ботом
    function BotWindow: cardinal;
    // Получить HWND окна с игрой
    function GameWindow: cardinal;
    // Заходит на персонажа (должны находится на панели выбора персонажей)
    function GameStart(CharIndex: integer = -1): boolean;
    // Выходит на панель выбора персонажей (чар не должен находиться в режиме боя)
    function Restart: boolean;
    // Закрывает клиент игры Lineage II
    function GameClose: boolean;
    // Фукнция для отправки сообщений игровому окну. Используется для нажатия клавиш клавиатуры / мышки.
    function PostMessage(Msg: cardinal; wParam, lParam: integer): integer;
    // Фукнция для отправки сообщений игровому окну. Используется для нажатия клавиш клавиатуры / мышки.
    function SendMessage(Msg: cardinal; wParam, lParam: integer): integer;
    // Развернуть / свернуть окно игры
    function SetGameWindow(Visible: boolean): boolean;
    // Задает величину отступа от краев карты
    procedure SetMapKeepDist(Value: integer);
    // Воскрешение персонажа
    function GoHome(ResType: TRestartType = rtTown): boolean;
    // Текущее игровое время
    function GameTime: cardinal;
    // Текущее время сервера
    function ServerTime: cardinal;
    // Текущий статус аккаунта
    function Status: TL2Status;
    // Ожидание события или группы событий
    function WaitAction(Actions: TL2Actions; var P1; var P2; TimeOut: cardinal = INFINITE): TL2Actions;
    // Напечатать текст (Нажать Enter > написать Txt > нажать Enter)
    function EnterText(const Txt: string): boolean;
    // Написать сообщение в чат
    function Say(const Text: string; ChatType: cardinal = 0; const Nick: string = ''): boolean;
    // Нажимает клавишу на клавиатуре
    function UseKey(const Key: string; Ctrl: boolean = False; Shift: boolean = False): boolean; overload;   // Нажить клавишу по названию
    function UseKey(Key: word; Ctrl: boolean = False; Shift: boolean = False): boolean; overload;   // Нажать клавишу, используя код кнопки
    // Вызов функции в скрипте другого аккаунта. Вызываемая функция должна иметь вид OnEntry
    function Entry(var Param): boolean;
    // Расчитывает путь между двумя точками с учетом нарисованной зоны и помещает точки в PathList подряд
    function FindPath(StartX, StartY, EndX, EndY: integer; PathList: TList): boolean;
    // Написать системное сообщение в окне бота, различного цвета (TColor - информация о цветах)
    procedure Msg(Who, What: string; Color: integer);
    // Проверка объекта на "занятость" другими игроками
    function IsBusy(Obj: TL2Npc): boolean;
    // Проверяет, день в игре или ночь? (день - true, ночь - false)
    function IsDay: boolean;
    // Покинуть наставника
    function KickMentor: boolean;
    // Узнать ник наставника
    function GetMentor: string;
    // Приглаить в группу игрока с указанным именем
    function InviteParty(const Name: string; Loot: TLootType = ldLooter): boolean;
    // Исключает игрока с указанным именем из группы
    function DismissParty(const Name: string): boolean;
    // Ответить на приглашение в группу
    function JoinParty(Join: boolean): boolean;
    // Выйти из группы
    function LeaveParty: boolean;
    // Передает лидерство в группе указанному игроку (Ваш персонаж должен быть лидером группы)
    function SetPartyLeader(const Name: string): boolean;
    // Отозывает пета (если есть)
    function DismissPet: boolean;
    // Отозывает самона (если есть)
    function DismissSum: boolean;
    // Начать диалог с NPC
    function DlgOpen: boolean;
    // Выбор диалогов
    function DlgSel(const Txt: string; const TimeOut: integer = 1000): boolean; overload;   // Выбирает при диалоге строку Txt
    function DlgSel(Index: integer; const TimeOut: integer = 1000): boolean; overload;   // Выбирает при диалоге строку с порядковым номером Index
    // Содержит полный текст текущего диалога
    function DlgText: string;
    // Отвечает на запросы Да/Нет
    function ConfirmDialog(Accept: boolean): boolean;
    // Получить диалог (объект класса TConfirmDlg)
    function ConfirmDlg: TConfirmDlg;
    // Отправить на сервер Bypass
    function BypassToServer(const S: string): boolean;
    // Автопринятие наставничества
    procedure AutoAcceptMentors(Names: string);
    // Автопринятие клана
    procedure AutoAcceptClan(Names: string);
    // Автопринятие командного канала
    procedure AutoAcceptCC(Names: string);
    // Использование скила по названию \ идентификатору
    function UseSkill(const Name: string; Ctrl: boolean = False; Shift: boolean = False): boolean; overload;   // Использование скила по названию
    function UseSkill(ID: cardinal; Ctrl: boolean = False; Shift: boolean = False): boolean; overload;   // Использование скила по ID
    // Использовать скил без проверки на откат / количество MP
    function DUseSkill(ID: cardinal; Ctrl, Shift: boolean): boolean;
    // Прервать чтение заклинания
    function StopCasting: boolean;
    // Снимает с нашего персонажа баф с указанным названием
    function Dispel(const Name: string): boolean;
    // Учит скил по ID (в HighFive и ниже должны находиться возле тренера)
    function LearnSkill(ID: cardinal): boolean;
    // Открывает окно умений (для Interlude серверов)
    function UpdateSkillList: boolean;
    // Использовать умение на указанные координаты
    function UseSkillGround(ID: cardinal; X, Y, Z: integer; Ctrl: boolean = False; Shift: boolean = False): boolean;
    // Обмен вещей у NPC
    function NpcExchange(ID: cardinal; Count: cardinal): boolean;
    // Покупка или продажа предметов торговцу
    function NpcTrade(Sell: boolean; Items: array of cardinal): boolean;
    // Процент налога в городе
    function CastleTax(TownID: cardinal): integer;
    // Открывает квестовый "знак вопроса" (требуется для некоторых квестов)
    function OpenQuestion: boolean;
    // Проверяет выполнен указанный шаг квеста или нет
    function QuestStatus(QuestID: cardinal; Step: integer): boolean;
    // Отменяет квест по указанному ID
    function CancelQuest(ID: integer): boolean;
    // Получить ежедневную награду
    function GetDailyItems: boolean;
    // Получает список игроков из другого аккаунта
    function GetCharList: TCharList;
    // Получает список дропа из другого аккаунта
    function GetDropList: TDropList;
    // Получает список инвентаря из другого аккаунта
    function GetInventory: TInventory;
    // Получает список NPC из другого аккаунта
    function GetNpcList: TNpcList;
    // Получает список группы из другого аккаунта
    function GetParty: TParty;
    // Получает список петов из другого аккаунта
    function GetPetList: TPetList;
    // Получает список умений из другого аккаунта
    function GetSkillList: TSkillList;
    // Получает объекта User (TL2User) из другого аккаунта
    function GetUser: TL2User;
    // Узнать статус кнопки интерфейса: включен\выключен? (FaceControl)
    function GetFaceState(ID: integer): boolean;
    // Использует предмет
    function UseItem(const Name: string; Pet: boolean = False): boolean; overload;   // Использовать предмет по названию
    function UseItem(ID: cardinal; Pet: boolean = False): boolean; overload;   // Использовать предмет по идентификатору
    function UseItem(Obj: TL2Item; Pet: boolean = False): boolean; overload;   // Использовать конкретный предмет
    // Работа со складом
    function LoadItems(ToWH: boolean; Items: array of cardinal): boolean;
    // Отдать пету / забрать у пета указанный предмет
    function MoveItem(const Name: string; Count: cardinal; ToPet: boolean): boolean;
    // Проверка экипировки
    function Equipped(const Name: string): integer;
    // Скрафтить предмет
    function MakeItem(Index: cardinal): boolean;
    // Разбить предмет на кристалы
    function CrystalItem(ID: cardinal): boolean;
    // Удаляет указанный предмет
    function DestroyItem(const Name: string; Count: cardinal): boolean; overload;   // Удалить предмет по названию
    function DestroyItem(ID: integer; Count: cardinal): boolean; overload;   // Удалить предмет по ID
    // Использование игровых действий
    function UseAction(ID: cardinal; Ctrl: boolean = False; Shift: boolean = False): boolean;
    // Сесть
    function Sit: boolean;
    // Встать
    function Stand: boolean;
    // Сделать Unstuck
    function Unstuck: boolean;
    // Создать комнату группы (подбор группы)
    function CreateRoom(Text: string; LevelStart, LevelEnd: integer): boolean;
    // Закрыть комнату группы
    function CloseRoom: boolean;
    // Открыть личную лавку (покупка \ продажа \ крафт)
    function OpenPrivateStore(PriceList: array of cardinal; StoreType: byte; StoreMsg: string): boolean;
    // Отправка почты
    function SendMail(const Recipient: string; const Theme: string; const Content: string; Items: array of cardinal; Price: cardinal = 0): boolean;
    // Принять почту
    function GetMailItems(MaxLoad: cardinal = 65; MaxCount: cardinal = 1000): boolean;
    // Очистить почтовый ящик
    function ClearMail: boolean;
  end;

implementation

begin
end.


