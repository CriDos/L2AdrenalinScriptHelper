//Версия 1.0 by CriDos
unit Adrenalin;

interface

uses
  Classes, SysUtils;

type
  // Состояния игры
  TL2Status = (
    lsOff,    //Отключен
    lsOnline, //Онлайн
    lsOffline //Оффлайн
    );

  // Классы объектов
  TL2Class = (
    lcError, //ошибка
    lcDrop,  //дроп
    lcNpc,   //NPC
    lcPet,   //пет
    lcChar,  //другие игроки
    lcUser,  //наш персонаж
    lcBuff,  //баф
    lcSkill, //скил
    lcItem   //предмет
    );

  //Тип рассы
  TL2Race = (
    rtHuman,   //Люди
    rtElf,     //Эльфы
    rtDarkElf, //Темные Эльфы
    rtOrc,     //Орки
    rtDwarf,   //Гномы
    rtKamael,  //Камаэль
    rtErthea,  //Артеи
    rtUnknown  //неизвестно
    );

  //Тип события для WaitAction
  TL2Actions = (
    laSpawn,        //появление в игровом мире (респ)
    laDelete,       //исчезание из игрового мира
    laPetSpawn,     //появление пета в игровом мире (респ)
    laPetDelete,    //исчезание пета из игрового мира
    laInvite,       //приглашение в пати
    laDie,          //смерть
    laRevive,       //воскрешение
    laTarget,       //взяли в таргет
    laUnTarget,     //отменили таргет
    laInGame,       //в игре
    laStatus,       //изменение статуса аккаунта
    laBuffs,        //наложение бафа
    laSkills,       //применение умений
    laDlg,          //выбор диалога
    laConfirmDlg,   //подтверждение диалога
    laStop,         //остановка
    laStartAttack,  //начало боя
    laStopAttack,   //прекращение боя
    laCast,         //начало каста
    laCancelCast,   //отмена каста
    laTeleport,     //телепортация
    laAutoSoulShot, //вкл\выкл автоиспользования сосок
    atTeleport,     //телепорт
    laNpcTrade,     //проведение сделки с торговцем
    laSysMsg,       //системное сообщение
    laKey           //нажатие кнопки
    );

  //Тип распределения лута
  TLootType = (
    ldLooter,      //Нашедшому
    ldRandom,      //Случайно
    ldRandomSpoil, //Случайно + присвоить
    ldOrder,       //По очереди
    ldOrderSpoil   //По очереди + присвоить
    );

  //Тип торговой лавки
  TStoreType = (
    stNone,               //отсутствует
    stSell,               //продажа
    stPrepareSell,        //производит настройки продажи
    stBuy,                //покупка
    stPrepareBuy,         //производит настройки покупки
    stManufacture,        //крафт
    stPrepareManufacture, //производит настройки крафта
    stObservingGames,     //смотрит игры
    stSellPackage         //продает пачкой
    );

  //Тип воскрешения
  TRestartType = (
    rtTown,     //в город
    rtClanHoll, //в клан хол
    rtCastle,   //в замок
    rtFort,     //в форт
    rtFlags     //к флагу
    );

  //Тип сообщения
  TMessageType = (
    mtSystem,  //системное
    mtAll,     //общий чат
    mtPrivate, //приватный чат
    mtParty,   //пати чат
    mtClan,    //клановый чат
    mtFriend,  //переписка с другом
    mtShout    //крик
    );

type
  // Базовый класс всех игровых объектов
  TL2Object = class
  public
    // ID объекта
    property ID: cardinal;
    // Имя объекта
    property Name: string;
    // Уникальный идентификатор для любого объекта в игре
    property OID: cardinal;
    // Проверка объекта на существование в игре (актуальность)
    property Valid: boolean;
    // Узнать класс к которому относится данный объект
    property L2Class: TL2Class;
    // Назначить объекту пользовательскую переменную
    procedure SetVar(Value: cardinal);
    // Получить значение пользовательской переменной
    function GetVar: cardinal;
  end;

  // Класс игровых эффектов
  TL2Effect = class(TL2Object)
  public
    // Уровень скила \ бафа
    function Level: cardinal;
    // Время до окончания действия (для эффектов) \ время отката умения (для скилов)
    function EndTime: cardinal;
  end;

  // Класс игровых предметов
  TL2Item = class(TL2Effect)
  public
    // Количество предметов (если стопка)
    function Count: int64;
    // Одета на нас вещь или нет
    function Equipped: boolean;
    // Уровень заточки предмета
    function EnchantLevel: word;
    // Тип предмета (0 оружие; 1 броня; 2 бижа; 5 ресурсы и все остальное)
    function ItemType: cardinal;
    // Грейд предмета
    function Grade: cardinal;
    // Название грейда предмета ('NG', 'D', 'C', 'B', 'A', 'S', 'S80', 'S84', 'R', 'R95', 'R99')
    function GradeName: string;
  end;

  // Родительский класс для всех списков в боте
  TL2List = class
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

  //Класс для управления списком айтемов
  TItemList = class(TL2List)
  public
    // Позволяет обратиться к объекту в списке по индексу
    function Items(Index: integer): TL2Item; overload;
  end;

  // Класс описывающий наши инвентари
  TInventory = class
  public
    // Инветарь нашего пета
    function Pet: TItemList;
    // Инветарь нашего персонажа
    function User: TItemList;
    // Инветарь нашего персонажа (квестовый)
    function Quest: TItemList;
  end;

  // Класс игровых предметов с аукциона
  TL2AucItem = class(TL2Item)
  public
    // Тип лота
    function LotType: cardinal;
    // Ник продавца
    function Seller: string;
    // Цена лота за которую можно выкупить предмет
    function Price: int64;
    // Время, на которое выставлен предмет
    function Days: cardinal;
    // Время до завершения торгов в секундах
    function EndTime: cardinal;
  end;

  // Класс управления списком аукционов
  TAuctionList = class(TL2List)
  public
    // Позволяет обратиться к объекту в списке по индексу
    function Items(Index: integer): TL2AucItem; overload;
  end;

  // Класс для работы с аукционом
  TL2Auction = class(TL2List)
  public
    // Формирует поисковый запрос. Результат помещается в объект Auction
    function Search(const Name: string; Grade: integer = -1; PageID: integer = 0): boolean;
    // Выставить предмет на продажу
    function SellItem(Item: TL2Item; Count, Price, Days: cardinal; CustomName: string = ''): boolean;
    // Купить предмет с аукциона
    function BuyItem(Item: TL2AucItem): boolean;
    // Получить список своих лотов продажи
    function GetMySales: boolean;
    // Снять предмет с продажи
    function CancelItem(Item: TL2AucItem): boolean;
    // Позволяет обратиться к объекту в списке по индексу
    property Items: TL2AucItem;
  end;

  // Класс умения, которое кастуются в данный момент
  TL2Cast = class(TL2Effect);

  // Класс игровых бафов
  TL2Buff = class(TL2Effect);

  // Класс управления списком игровых бафов
  TBuffList = class(TL2List)
  public
    // Позволяет обратиться к объекту в списке по индексу
    function Items(Index: integer): TL2Buff; overload;
  end;

  // Класс всех объектов имеющих координаты
  TL2Spawn = class(TL2Object)
  public
    // Координата X объекта
    function X: integer;
    // Координата Y объекта
    function Y: integer;
    // Координата Z объекта
    function Z: integer;
    // Возвращает дистанцию до заданной точки
    function DistTo(X: integer; Y: integer; Z: integer): cardinal; overload;
    // Возвращает дистанцию до объекта
    function DistTo(Obj: TL2Spawn): cardinal; overload;
    // Время, которое прошло со времени появления объекта в игровом мире (в мс)
    function SpawnTime: cardinal;
    // Проверка объекта в радиусе Range от точки (x, y, z)
    function InRange(X: integer; Y: integer; Z: integer; Range: cardinal; ZRange: cardinal = 250): boolean;
    // Проверка на вхождение объекта в зону охоты
    function InZone: boolean;
  end;

  // Класс управления списком игровых объектов
  TSpawnList = class(TL2List)
  public
    // Позволяет обратиться к объекту в списке по индексу
    function Items(Index: integer): TL2Spawn; overload;
  end;

  // Класс живых объектов в игре (игроки, NPC, петы и тд)
  TL2Live = class(TL2Spawn)
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

  // Класс всех игроков
  TL2Char = class(TL2Live)
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
    //TODO Добавить описание
    property BaseClass: TBaseClass read GetClassInfo;
    //TODO Добавить описание
    property Crest: TL2Crest read GetCrest;
    //TODO Добавить описание
    property L2Clan: TL2Clan read GetClan;
  end;

  // Класс управления списком игроков
  TCharList = class(TL2List)
  public
    // Позволяет обратиться к объекту в списке по индексу
    function Items(Index: integer): TL2Char; overload;
  end;

  // Класс выпадающего с мобов дропа
  TL2Drop = class(TL2Spawn)
  public
    // Количество итемов в одной "кучке"
    function Count: int64;
    // Дроп принадлежит нам или нет ("Нам" - если выбил наш чар, пет или члены пати)
    function IsMy: boolean;
    // Стопковый предмет или не может стакаться
    function Stackable: boolean;
  end;

  // Класс управления списком дропа c мобов
  TDropList = class(TL2List)
  public
    // Позволяет обратиться к объекту в списке по индексу
    function Items(Index: integer): TL2Drop; overload;
  end;

  // Класс NPC
  TL2Npc = class(TL2Live)
  public
    // Является объект петом или нет
    function IsPet: boolean;
    // Тип пета (самон или пет)
    function PetType: cardinal;
  end;

  // Класс управления списком NPC
  TNpcList = class(TL2List)
  public
    // Позволяет обратиться к объекту в списке по индексу
    function Items(Index: integer): TL2Npc; overload;
  end;

  // Класс наших петов/самонов
  TL2Pet = class(TL2Npc)
  public
    // Голод питомца (еда) в процентах
    function Fed: cardinal;
  end;

  // Класс управления списком игровых петов
  TPetList = class(TL2List)
  public
    // Позволяет обратиться к объекту в списке по индексу
    function Items(Index: integer): TL2Pet; overload;
  end;

  // Класс скриптов, доступен по имени Script
  TL2Script = class
  public
    // Остановка выполнения скрипта
    procedure Stop;
    // Приостановка выполнения скрипта
    procedure Pause;
    // Приостановка всех потоков, кроме текущего
    procedure Suspend;
    // Восстановление работы всех потоков
    procedure Resume;
    // Создание нового потока
    procedure NewThread(Address: Pointer);
    // Перезапуск текущего скрипта или запуск нового
    function Replace(const Name: string = ''): boolean;
    // Путь к файлу скрипта
    function Path: string;
    // Вызов процедуры в основном потоке программы
    procedure MainProc(Proc: Pointer);
    // Запуск плагина
    function StartPlugin(const PluginName: string; PProc: Pointer; ShowModal: boolean): boolean;
    //TODO Добавить описание
    function OnPluginProc(Code: cardinal; p1: WideString): integer;
  end;

  // Класс игровых умений
  TL2Skill = class(TL2Effect)
  public
    // Доступен ли скил
    function Disabled: boolean;
    // Проточен ли скил
    function Enchanted: boolean;
    // Пассивный скил или нет
    function Passive: boolean;
  end;

  // Класс управления списком игровых умений
  TSkillList = class(TL2List)
  public
    // Позволяет обратиться к объекту в списке по индексу
    function Items(Index: integer): TL2Skill; overload;
  end;

  // Класс нашего персонажа
  TL2User = class(TL2Char)
  public
    // Может кристализовать предметы наш герой или нет?
    function CanCryst: boolean;
    // Количество зарядок (для гладов \ тирантов)
    function Charges: cardinal;
    // Штраф от перевеса
    function WeightPenalty: cardinal;
    // Штраф за ношение оружия неподходящего грейда
    function WeapPenalty: cardinal;
    // Штраф за ношение брони неподходящего грейда
    function ArmorPenalty: cardinal;
    // Штраф за смерть
    function DeathPenalty: cardinal;
    // Количество душ (для камаэлей)
    function Souls: cardinal;
  end;

  // Класс описывающий наш склад
  TL2WareHouse = class(TL2List)
  public
    // Тип инвентаря
    property WHType: word;
    // Количество адены на складе
    property Adena: int64;
    // Список предметов на нашем складе
    function Items(Index: integer): TL2Item;
  end;

  // Класс описывающий нашу группу
  TParty = class
  public
    // Список петов в группе
    function Pets: TNpcList;
    // Список чаров в группе
    function Chars: TCharList;
    // Тип распределения лута в группе
    function LootType: TLootType;
    // Лидер группы
    function Leader: TL2Char;
  end;

  // Класс управления игровыми действиями, доступен по имени Engine. Можно управлять другим окном с помощью GetControl
  TL2Control = class
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
    // Взять в таргет по имени
    function SetTarget(const Name: string): boolean; overload;
    // Взять в таргет по ID
    function SetTarget(ID: cardinal): boolean; overload;
    // Взять в таргет объект Obj
    function SetTarget(Obj: TL2Live): boolean; overload;
    // Сбрасывает таргет
    function CancelTarget: boolean;
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
    // Нажить клавишу по названию
    function UseKey(const Key: string; Ctrl: boolean = False; Shift: boolean = False): boolean; overload;
    // Нажать клавишу, используя код кнопки
    function UseKey(Key: word; Ctrl: boolean = False; Shift: boolean = False): boolean; overload;
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
    // Выбирает при диалоге строку Txt
    function DlgSel(const Txt: string; const TimeOut: integer = 1000): boolean; overload;
    // Выбирает при диалоге строку с порядковым номером Index
    function DlgSel(Index: integer; const TimeOut: integer = 1000): boolean; overload;
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
    // Использование скила по названию
    function UseSkill(const Name: string; Ctrl: boolean = False; Shift: boolean = False): boolean; overload;
    // Использование скила по ID
    function UseSkill(ID: cardinal; Ctrl: boolean = False; Shift: boolean = False): boolean; overload;
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
    // Использовать предмет по названию
    function UseItem(const Name: string; Pet: boolean = False): boolean; overload;
    // Использовать предмет по идентификатору
    function UseItem(ID: cardinal; Pet: boolean = False): boolean; overload;
    // Использовать конкретный предмет
    function UseItem(Obj: TL2Item; Pet: boolean = False): boolean; overload;
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
    // Удалить предмет по названию
    function DestroyItem(const Name: string; Count: cardinal): boolean; overload;
    // Удалить предмет по ID
    function DestroyItem(ID: integer; Count: cardinal): boolean; overload;
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

  // Класс точек GPS баз
  TGpsPoint = class
  public
    // Координата X
    property X: integer;
    // Координата Y
    property Z: integer;
    // Координата Z
    property Name: string;
  end;

  // Класс навигации персонажа
  TGps = class
  public
    // Общее количество точек
    function Count: integer;
    // Загрузка базы Gps, возвращает кол-во загруженных точек
    function LoadBase(const FilePath: string): integer;
    // Прокладывает маршрут от точки (X1, Y1, Z1) до (X2, Y2, Z2) и записывает точки этого маршрута в GPS.Items. Возвращает длину проложенного маршрута
    function GetPath(X1, Y1, Z1, X2, Y2, Z2: single): integer;
    // Прокладывает маршрут до точки по ее названию и записывает точки этого маршрута в GPS.Items. Возвращает длину проложенного маршрута
    function GetPathByName(X1, Y1, Z1: single; PointName: string): integer;
    // Возвращает точку с указанным индексом
    function Items(Index: integer): TGpsPoint;
  end;

  // Класс внутриигровых сообщений
  TChatMessage = class
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

  // Класс диалоговых окон с подтверждением
  TConfirmDlg = class
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

//Служебные
type
  TShMem = array[1..1000] of integer;

var
  //Глобальный массив, доступный всем аккаунтам
  ShMem: TShMem;
  //Скрипт
  Script: TL2Script;
  //Движок управления персонажем
  Engine: TL2Control;
  //Наш персонаж
  User: TL2User;
  //Список лотов на аукционе
  Auction: TAuctionList;
  //Список всех объектов, имеющих координаты
  SpawnList: TSpawnList;
  //Список всех видимых NPC
  NpcList: TNpcList;
  //Список всех петов
  PetList: TPetList;
  //Список игроков
  CharList: TCharList;
  //Список лежащего на земле дропа
  DropList: TDropList;
  //Список доступных нашему персонажу умений
  SkillList: TSkillList;
  //Список доступных нашему персонажу предметов
  ItemList: TItemList;
  //Список предметов на складе
  WareHouse: TItemList;
  //Объект, содержащий списки наших инвентарей (квестовый \ пета \ игрока)
  Inventory: TInventory;
  //Буфер, хранящий последнюю информацию о чате
  ChatMessage: TChatMessage;

//Задержка\пауза на указанное время
function Delay(ms: cardinal): boolean;
//Воспроизведение звука
procedure PlaySound(const FileName: string; Loop: boolean = False);
//Остановка воспроизведения звуков
procedure StopSound;
//Возвращает путь к папке с ASI WIN
function ExePath: string;
//Сквозной таймер
function TimerEx(var Value: cardinal; Delay: cardinal): boolean;
//Получение уникального кода компьютера
function GetHWID: cardinal;
//Получение уникального ID (хэш) основанный на ботлогине
function BotLoginID: cardinal;
//Получить контроль над дугим персонажем
function GetControl(Nick: string): TL2Control;
//Получить контроль над дугим персонажем по его индексу в списке аккаунтов
function GetControlByIndex(Index: integer): TL2Control;
//Обработчик событий во время бега (смерть \ дисконнект \ нападение моба)
procedure OnMoveEvent(Attacker: TL2Live; var BreakMove: boolean);
//Функция, вызываемая с помощью Engine.Entry из другого скрипта
function OnEntry(var Param): boolean;
//Вызывается при завершении работы скрипта
procedure OnFree;
//Преобразование координат в строку
function FToStr(Value: single): string;
//Преобразует память в Hex строку
function MemToHex(const dt; size: word; sep: char = #0): string; overload;
//Преобразует память в Hex строку
function MemToHex(const Mem: ansistring): string; overload;
//Преобразует Hex строку в память
function HexToMem(const Hex: string; var Buf): cardinal; overload;
//Преобразует Hex строку в память
function HexToMem(const Hex: string): ansistring; overload;
//Вывод информации в консоль
procedure Print(dt);

implementation

begin
end.
