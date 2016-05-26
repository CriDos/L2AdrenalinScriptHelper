//Версия 1.1.0 by CriDos
unit Adrenalin;

{$mode Delphi}{$H+}

interface

uses
  Classes, variants;

//Служебные
type
  TShMem = array[1..1000] of integer;

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

  //Тип воскрешения для TL2Control.GoHome
  TRestartType = (
    rtTown,     //в город
    rtClanHoll, //в клан хол
    rtCastle,   //в замок
    rtFort,     //в форт
    rtFlags     //к флагу
    );

  //Тип сообщения для ChatMessage.Type
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
  private
    GetID: cardinal;
    // Имя объекта
    GetName: string;
    // Уникальный идентификатор для любого объекта в игре
    GetOID: cardinal;
    // Проверка объекта на существование в игре (актуальность)
    GetValid: boolean;
    // Узнать класс к которому относится данный объект
    GetL2Class: TL2Class;

  public
    // ID объекта
    property ID: cardinal read GetID;
    // Имя объекта
    property Name: string read GetName;
    // Уникальный идентификатор для любого объекта в игре
    property OID: cardinal read GetOID;
    // Проверка объекта на существование в игре (актуальность)
    property Valid: boolean read GetValid;
    // Узнать класс к которому относится данный объект
    property L2Class: TL2Class read GetL2Class;
    // Назначить объекту пользовательскую переменную
    procedure SetVar({%H-}Value: cardinal);
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
    function ByID({%H-}ID: cardinal; var {%H-}Obj): boolean;
    // Поиск объекта в списке по OID. Если объект найден, он помещается в переменную Obj
    function ByOID({%H-}OID: cardinal; var {%H-}Obj): boolean;
    // Поиск объекта в списке по имени. Если объект найден, он помещается в переменную Obj
    function ByName(const {%H-}Name: string; var {%H-}Obj): boolean;
    // Количество объектов в списке
    function Count: integer;
    // Позволяет обратиться к объекту в списке по индексу
    function Items({%H-}Index: integer): TL2Object;
  end;

  //Класс для управления списком айтемов
  TItemList = class(TL2List)
  public
    // Позволяет обратиться к объекту в списке по индексу
    function Items({%H-}Index: integer): TL2Item; overload;
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
    function Items({%H-}Index: integer): TL2AucItem; overload;
  end;

  // Класс для работы с аукционом
  TL2Auction = class(TL2List)
  private
    // Позволяет обратиться к объекту в списке по индексу
    GetItems: TL2AucItem;
  public
    // Формирует поисковый запрос. Результат помещается в объект Auction
    function Search(const {%H-}Name: string; {%H-}Grade: integer = -1; {%H-}PageID: integer = 0): boolean;
    // Выставить предмет на продажу
    function SellItem({%H-}_Item: TL2Item; {%H-}_Count, {%H-}_Price, {%H-}_Days: cardinal; {%H-}_CustomName: string = ''): boolean;
    // Купить предмет с аукциона
    function BuyItem({%H-}Item: TL2AucItem): boolean;
    // Получить список своих лотов продажи
    function GetMySales: boolean;
    // Снять предмет с продажи
    function CancelItem({%H-}Item: TL2AucItem): boolean;
    // Позволяет обратиться к объекту в списке по индексу
    property Items: TL2AucItem read GetItems;
  end;

  // Класс умения, которое кастуется в данный момент
  TL2Cast = class(TL2Effect);

  // Класс игровых бафов
  TL2Buff = class(TL2Effect);

  // Класс управления списком игровых бафов
  TBuffList = class(TL2List)
  public
    // Позволяет обратиться к объекту в списке по индексу
    function Items({%H-}Index: integer): TL2Buff; overload;
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
    function DistTo({%H-}_X: integer; {%H-}_Y: integer; {%H-}_Z: integer): cardinal; overload;
    // Возвращает дистанцию до объекта
    function DistTo({%H-}Obj: TL2Spawn): cardinal; overload;
    // Время, которое прошло со времени появления объекта в игровом мире (в мс)
    function SpawnTime: cardinal;
    // Проверка объекта в радиусе Range от точки (x, y, z)
    function InRange({%H-}_X: integer; {%H-}_Y: integer; {%H-}_Z: integer; {%H-}_Range: cardinal; {%H-}_ZRange: cardinal = 250): boolean;
    // Проверка на вхождение объекта в зону охоты
    function InZone: boolean;
  end;

  // Класс управления списком игровых объектов
  TSpawnList = class(TL2List)
  public
    // Позволяет обратиться к объекту в списке по индексу
    function Items({%H-}Index: integer): TL2Spawn; overload;
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

  //Bitmap? герба
  TL2Crest = array of integer;
  //Bitmap? клана
  TL2Clan = array of integer;

  // Класс всех игроков
  TL2Char = class(TL2Live)
  private
    //GetClassInfo: string;
    //GetCrest: TL2Crest;
    //GetClan: TL2Clan;
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
    function L2Class: TL2Class;
    //Неизвестное свойство
    //property BaseClass: TBaseClass read GetClassInfo;
    // Получаем изображение герба в формате Bitmap?
    //property Crest: TL2Crest read GetCrest;
    // Получаем изображение клана в формате Bitmap?
    //property L2Clan: TL2Clan read GetClan;
  end;

  // Класс управления списком игроков
  TCharList = class(TL2List)
  public
    // Позволяет обратиться к объекту в списке по индексу
    function Items({%H-}Index: integer): TL2Char; overload;
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
    function Items({%H-}Index: integer): TL2Drop; overload;
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
    function Items({%H-}Index: integer): TL2Npc; overload;
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
    function Items({%H-}Index: integer): TL2Pet; overload;
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
    procedure NewThread({%H-}Address: Pointer);
    // Перезапуск текущего скрипта или запуск нового
    function Replace(const {%H-}Name: string = ''): boolean;
    // Путь к файлу скрипта
    function Path: string;
    // Вызов процедуры в основном потоке программы
    procedure MainProc({%H-}Proc: Pointer);
    // Запуск плагина
    function StartPlugin(const {%H-}PluginName: string; {%H-}PProc: Pointer; {%H-}ShowModal: boolean): boolean;
    //TODO Добавить описание
    function OnPluginProc({%H-}Code: cardinal; {%H-}p1: WideString): integer;
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
    function Items({%H-}Index: integer): TL2Skill; overload;
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
  private
    GetWHType: word;
    GetAdena: int64;
  public
    // Тип инвентаря
    property WHType: word read GetWHType;
    // Количество адены на складе
    property Adena: int64 read GetAdena;
    // Список предметов на нашем складе
    function Items({%H-}Index: integer): TL2Item;
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

  // Класс управления игровыми действиями, доступен по имени Engine. Можно управлять другим окном с помощью GetControl
  TL2Control = class
  public
    // Двигаться в точку
    function MoveTo({%H-}X, {%H-}Y, {%H-}Z: integer; const {%H-}TimeOut: integer = 8000): boolean; overload;
    // Подойти к объекту
    function MoveTo({%H-}Obj: TL2Spawn; {%H-}Dist: integer): boolean; overload;
    // Двигаться в указанную точку без ожидания результата
    function DMoveTo({%H-}x, {%H-}y, {%H-}z: integer): boolean;
    // Подойти к выбранной цели на указанную дистанцию
    function MoveToTarget({%H-}Dist: integer = -100): boolean;
    // Купить предмет с аукциона
    function AuctionBuyItem({%H-}Item: TL2AucItem): boolean;
    // Снять предмет с продажи
    function AuctionCancelItem({%H-}Item: TL2AucItem): boolean;
    // Получить список своих лотов продажи
    function AuctionGetMySales: boolean;
    // Формирует поисковый запрос. Результат помещается в объект Auction
    function AuctionSearch(const {%H-}Name: string; {%H-}Grade: integer = -1; {%H-}PageID: integer = 0): boolean;
    // Выставить предмет на продажу
    function AuctionSellItem({%H-}Item: TL2Item; {%H-}Count, {%H-}Price, {%H-}Days: cardinal; {%H-}CustomName: string = ''): boolean;
    // Делает своей целью цель указанного игрока или NPC
    function Assist(const {%H-}Name: string): boolean;
    // Атака
    function Attack({%H-}TimeOut: cardinal = 2000; {%H-}Ctrl: boolean = False): boolean;
    // Включает/выключает автоматическое использование сосок (зарядов души\духа)
    function AutoSoulShot(const {%H-}Name: string; {%H-}Active: boolean): boolean;
    // Авто-подбор цели
    function AutoTarget({%H-}Range: cardinal = 2000; {%H-}ZRange: cardinal = 300; {%H-}NotBusy: boolean = True): boolean;
    // Поиск "врага" для заданного объекта в указанном радиусе (относительно объекта). Найденный "враг" будет записан в переменную Enemy.
    function FindEnemy(var {%H-}Enemy: TL2Live; {%H-}Obj: TL2Live; {%H-}Range: cardinal = 2000; {%H-}ZRange: cardinal = 300): boolean;
    // Взять в таргет по имени
    function SetTarget(const {%H-}Name: string): boolean; overload;
    // Взять в таргет по ID
    function SetTarget({%H-}ID: cardinal): boolean; overload;
    // Взять в таргет объект Obj
    function SetTarget({%H-}Obj: TL2Live): boolean; overload;
    // Сбрасывает таргет
    function CancelTarget: boolean;
    // Подобирает указанный объект
    function PickUp({%H-}Obj: TL2Drop; {%H-}Pet: boolean = False): boolean; overload;
    // Авто-подбор всего дропа в указанном радиусе
    function PickUp({%H-}Range: cardinal = 250; {%H-}ZRange: cardinal = 150; {%H-}OnlyMy: boolean = False; {%H-}Pet: boolean = False): integer; overload;
    // Включить / отключить интерфеис
    function FaceControl({%H-}ID: integer; {%H-}Active: boolean): boolean;
    // Загрузка конфига с указанным именем. По умолчанию из папки Settings, но можно указать полный путь.
    function LoadConfig(const {%H-}Name: string): boolean;
    // Загрузка боевой зоны из файла
    function LoadZone(const {%H-}Name: string): boolean;
    // Очистка всех зон на карте
    procedure ClearZone;
    // Добавляет объект в список игнгора. Методы AutoTarget и AutoPickup пропускают такие объекты
    procedure Ignore({%H-}Obj: TL2Spawn);
    // Очищает список игнора
    procedure ClearIgnore;
    // Объект находится в зоне?
    function InZone({%H-}Obj: TL2Spawn): boolean; overload;
    // Точка находится в зоне?
    function InZone({%H-}X, {%H-}Y, {%H-}Z: integer): boolean; overload;
    // Мигает окном на панели задач
    function BlinkWindow({%H-}GameWindow: boolean): boolean;
    // Получить HWND окна с ботом
    function BotWindow: cardinal;
    // Получить HWND окна с игрой
    function GameWindow: cardinal;
    // Заходит на персонажа (должны находится на панели выбора персонажей)
    function GameStart({%H-}CharIndex: integer = -1): boolean;
    // Выходит на панель выбора персонажей (чар не должен находиться в режиме боя)
    function Restart: boolean;
    // Закрывает клиент игры Lineage II
    function GameClose: boolean;
    // Фукнция для отправки сообщений игровому окну. Используется для нажатия клавиш клавиатуры / мышки.
    function PostMessage({%H-}Msg: cardinal; {%H-}wParam, {%H-}lParam: integer): integer;
    // Фукнция для отправки сообщений игровому окну. Используется для нажатия клавиш клавиатуры / мышки.
    function SendMessage({%H-}Msg: cardinal; {%H-}wParam, {%H-}lParam: integer): integer;
    // Развернуть / свернуть окно игры
    function SetGameWindow({%H-}Visible: boolean): boolean;
    // Задает величину отступа от краев карты
    procedure SetMapKeepDist({%H-}Value: integer);
    // Воскрешение персонажа
    function GoHome({%H-}ResType: TRestartType = rtTown): boolean;
    // Текущее игровое время
    function GameTime: cardinal;
    // Текущее время сервера
    function ServerTime: cardinal;
    // Текущий статус аккаунта
    function Status: TL2Status;
    // Ожидание события или группы событий
    function WaitAction({%H-}Actions: TL2Actions; var {%H-}P1; var {%H-}P2; {%H-}TimeOut: cardinal = High(cardinal)): TL2Actions;
    // Напечатать текст (Нажать Enter > написать Txt > нажать Enter)
    function EnterText(const {%H-}Txt: string): boolean;
    // Написать сообщение в чат
    function Say(const {%H-}Text: string; {%H-}ChatType: cardinal = 0; const {%H-}Nick: string = ''): boolean;
    // Нажить клавишу по названию
    function UseKey(const {%H-}Key: string; {%H-}Ctrl: boolean = False; {%H-}Shift: boolean = False): boolean; overload;
    // Нажать клавишу, используя код кнопки
    function UseKey({%H-}Key: word; {%H-}Ctrl: boolean = False; {%H-}Shift: boolean = False): boolean; overload;
    // Вызов функции в скрипте другого аккаунта. Вызываемая функция должна иметь вид OnEntry
    function Entry(var {%H-}Param): boolean;
    // Расчитывает путь между двумя точками с учетом нарисованной зоны и помещает точки в PathList подряд
    function FindPath({%H-}StartX, {%H-}StartY, {%H-}EndX, {%H-}EndY: integer; {%H-}PathList: TList): boolean;
    // Написать системное сообщение в окне бота, различного цвета (TColor - информация о цветах)
    procedure Msg({%H-}Who, {%H-}What: string; {%H-}Color: integer);
    // Проверка объекта на "занятость" другими игроками
    function IsBusy({%H-}Obj: TL2Npc): boolean;
    // Проверяет, день в игре или ночь? (день - true, ночь - false)
    function IsDay: boolean;
    // Покинуть наставника
    function KickMentor: boolean;
    // Узнать ник наставника
    function GetMentor: string;
    // Приглаить в группу игрока с указанным именем
    function InviteParty(const {%H-}Name: string; {%H-}Loot: TLootType = ldLooter): boolean;
    // Исключает игрока с указанным именем из группы
    function DismissParty(const {%H-}Name: string): boolean;
    // Ответить на приглашение в группу
    function JoinParty({%H-}Join: boolean): boolean;
    // Выйти из группы
    function LeaveParty: boolean;
    // Передает лидерство в группе указанному игроку (Ваш персонаж должен быть лидером группы)
    function SetPartyLeader(const {%H-}Name: string): boolean;
    // Отозывает пета (если есть)
    function DismissPet: boolean;
    // Отозывает самона (если есть)
    function DismissSum: boolean;
    // Начать диалог с NPC
    function DlgOpen: boolean;
    // Выбирает при диалоге строку Txt
    function DlgSel(const {%H-}Txt: string; const {%H-}TimeOut: integer = 1000): boolean; overload;
    // Выбирает при диалоге строку с порядковым номером Index
    function DlgSel({%H-}Index: integer; const {%H-}TimeOut: integer = 1000): boolean; overload;
    // Содержит полный текст текущего диалога
    function DlgText: string;
    // Отвечает на запросы Да/Нет
    function ConfirmDialog({%H-}Accept: boolean): boolean;
    // Получить диалог (объект класса TConfirmDlg)
    function ConfirmDlg: TConfirmDlg;
    // Отправить на сервер Bypass
    function BypassToServer(const {%H-}S: string): boolean;
    // Автопринятие наставничества
    procedure AutoAcceptMentors({%H-}Names: string);
    // Автопринятие клана
    procedure AutoAcceptClan({%H-}Names: string);
    // Автопринятие командного канала
    procedure AutoAcceptCC({%H-}Names: string);
    // Использование скила по названию
    function UseSkill(const {%H-}Name: string; {%H-}Ctrl: boolean = False; {%H-}Shift: boolean = False): boolean; overload;
    // Использование скила по ID
    function UseSkill({%H-}ID: cardinal; {%H-}Ctrl: boolean = False; {%H-}Shift: boolean = False): boolean; overload;
    // Использовать скил без проверки на откат / количество MP
    function DUseSkill({%H-}ID: cardinal; {%H-}Ctrl, {%H-}Shift: boolean): boolean;
    // Прервать чтение заклинания
    function StopCasting: boolean;
    // Снимает с нашего персонажа баф с указанным названием
    function Dispel(const {%H-}Name: string): boolean;
    // Учит скил по ID (в HighFive и ниже должны находиться возле тренера)
    function LearnSkill({%H-}ID: cardinal): boolean;
    // Открывает окно умений (для Interlude серверов)
    function UpdateSkillList: boolean;
    // Использовать умение на указанные координаты
    function UseSkillGround({%H-}ID: cardinal; {%H-}X, {%H-}Y, {%H-}Z: integer; {%H-}Ctrl: boolean = False; {%H-}Shift: boolean = False): boolean;
    // Обмен вещей у NPC
    function NpcExchange({%H-}ID: cardinal; {%H-}Count: cardinal): boolean;
    // Покупка или продажа предметов торговцу
    function NpcTrade({%H-}Sell: boolean; {%H-}Items: array of cardinal): boolean;
    // Процент налога в городе
    function CastleTax({%H-}TownID: cardinal): integer;
    // Открывает квестовый "знак вопроса" (требуется для некоторых квестов)
    function OpenQuestion: boolean;
    // Проверяет выполнен указанный шаг квеста или нет
    function QuestStatus({%H-}QuestID: cardinal; {%H-}Step: integer): boolean;
    // Отменяет квест по указанному ID
    function CancelQuest({%H-}ID: integer): boolean;
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
    function GetFaceState({%H-}ID: integer): boolean;
    // Использовать предмет по названию
    function UseItem(const {%H-}Name: string; {%H-}Pet: boolean = False): boolean; overload;
    // Использовать предмет по идентификатору
    function UseItem({%H-}ID: cardinal; {%H-}Pet: boolean = False): boolean; overload;
    // Использовать конкретный предмет
    function UseItem({%H-}Obj: TL2Item; {%H-}Pet: boolean = False): boolean; overload;
    // Работа со складом
    function LoadItems({%H-}ToWH: boolean; {%H-}Items: array of cardinal): boolean;
    // Отдать пету / забрать у пета указанный предмет
    function MoveItem(const {%H-}Name: string; {%H-}Count: cardinal; {%H-}ToPet: boolean): boolean;
    // Проверка экипировки
    function Equipped(const {%H-}Name: string): integer;
    // Скрафтить предмет
    function MakeItem({%H-}Index: cardinal): boolean;
    // Разбить предмет на кристалы
    function CrystalItem({%H-}ID: cardinal): boolean;
    // Удалить предмет по названию
    function DestroyItem(const {%H-}Name: string; {%H-}Count: cardinal): boolean; overload;
    // Удалить предмет по ID
    function DestroyItem({%H-}ID: integer; {%H-}Count: cardinal): boolean; overload;
    // Использование игровых действий
    function UseAction({%H-}ID: cardinal; {%H-}Ctrl: boolean = False; {%H-}Shift: boolean = False): boolean;
    // Сесть
    function Sit: boolean;
    // Встать
    function Stand: boolean;
    // Сделать Unstuck
    function Unstuck: boolean;
    // Создать комнату группы (подбор группы)
    function CreateRoom({%H-}Text: string; {%H-}LevelStart, {%H-}LevelEnd: integer): boolean;
    // Закрыть комнату группы
    function CloseRoom: boolean;
    // Открыть личную лавку (покупка \ продажа \ крафт)
    function OpenPrivateStore({%H-}PriceList: array of cardinal; {%H-}StoreType: byte; {%H-}StoreMsg: string): boolean;
    // Отправка почты
    function SendMail(const {%H-}Recipient: string; const {%H-}Theme: string; const {%H-}Content: string; {%H-}Items: array of cardinal; {%H-}Price: cardinal = 0): boolean;
    // Принять почту
    function GetMailItems({%H-}MaxLoad: cardinal = 65; {%H-}MaxCount: cardinal = 1000): boolean;
    // Очистить почтовый ящик
    function ClearMail: boolean;
  end;

  // Класс точек GPS баз
  TGpsPoint = class
  private
    // Координата X
    GetX: integer;
    // Координата Y
    GetZ: integer;
    // Координата Z
    GetName: string;
  public
    // Координата X
    property X: integer read GetX;
    // Координата Y
    property Z: integer read GetZ;
    // Координата Z
    property Name: string read GetName;
  end;

  // Класс навигации персонажа
  TGps = class
  public
    // Общее количество точек
    function Count: integer;
    // Загрузка базы Gps, возвращает кол-во загруженных точек
    function LoadBase(const {%H-}FilePath: string): integer;
    // Прокладывает маршрут от точки (X1, Y1, Z1) до (X2, Y2, Z2) и записывает точки этого маршрута в GPS.Items. Возвращает длину проложенного маршрута
    function GetPath({%H-}X1, {%H-}Y1, {%H-}Z1, {%H-}X2, {%H-}Y2, {%H-}Z2: single): integer;
    // Прокладывает маршрут до точки по ее названию и записывает точки этого маршрута в GPS.Items. Возвращает длину проложенного маршрута
    function GetPathByName({%H-}X1, {%H-}Y1, {%H-}Z1: single; {%H-}PointName: string): integer;
    // Возвращает точку с указанным индексом
    function Items({%H-}Index: integer): TGpsPoint;
  end;

  // Класс внутриигровых сообщений
  TChatMessage = class
  private
    // Сообщение не прочитано нами?
    GetUnread: boolean;
    // Ник отправителя
    GetSender: string;
    // Текст сообщения
    GetText: string;
    // Тип сообщения
    GetChatType: TMessageType;
  public
    // Сообщение не прочитано нами?
    property Unread: boolean read GetUnread;
    // Ник отправителя
    property Sender: string read GetSender;
    // Текст сообщения
    property Text: string read GetText;
    // Тип сообщения
    property ChatType: TMessageType read GetChatType;
  end;

//!!! Глобальные объекты !!!
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

//!!! Глобальные функции/процедуры !!!

//Задержка\пауза на указанное время
function Delay({%H-}ms: cardinal): boolean;
//Воспроизведение звука
procedure PlaySound(const {%H-}FileName: string; {%H-}Loop: boolean = False);
//Остановка воспроизведения звуков
procedure StopSound;
//Возвращает путь к папке с ASI WIN
function ExePath: string;
//Сквозной таймер
function TimerEx(var {%H-}Value: cardinal; {%H-}Delay: cardinal): boolean;
//Получение уникального кода компьютера
function GetHWID: cardinal;
//Получение уникального ID (хэш) основанный на ботлогине
function BotLoginID: cardinal;
//Получить контроль над дугим персонажем
function GetControl({%H-}Nick: string): TL2Control;
//Получить контроль над дугим персонажем по его индексу в списке аккаунтов
function GetControlByIndex({%H-}Index: integer): TL2Control;
//Обработчик событий во время бега (смерть \ дисконнект \ нападение моба)
procedure OnMoveEvent({%H-}Attacker: TL2Live; var {%H-}BreakMove: boolean);
//Функция, вызываемая с помощью Engine.Entry из другого скрипта
function OnEntry(var {%H-}Param): boolean;
//Вызывается при завершении работы скрипта
procedure OnFree;
//Преобразование координат в строку
function FToStr({%H-}Value: {%H-}single): string;
//Преобразует память в Hex строку
function MemToHex(const {%H-}dt; {%H-}size: word; {%H-}sep: char = #0): string; overload;
//Преобразует память в Hex строку
function MemToHex(const {%H-}Mem: ansistring): string; overload;
//Преобразует Hex строку в память
function HexToMem(const {%H-}Hex: string; var {%H-}Buf): cardinal; overload;
//Преобразует Hex строку в память
function HexToMem(const {%H-}Hex: string): ansistring; overload;
//Вывод информации в окно сообщений
procedure Print(const {%H-}msg: Variant);

implementation

procedure NOP; inline;
begin
  Delay(0);
end;

procedure TL2Object.SetVar(Value: cardinal);
begin
  NOP;
end;

function TL2Object.GetVar: cardinal;
begin
  Result := 0;
end;

function TL2Effect.Level: cardinal;
begin
  Result := 0;
end;

function TL2Effect.EndTime: cardinal;
begin
  Result := 0;
end;

function TL2Item.Count: int64;
begin
  Result := 0;
end;

function TL2Item.Equipped: boolean;
begin
  Result := False;
end;

function TL2Item.EnchantLevel: word;
begin
  Result := 0;
end;

function TL2Item.ItemType: cardinal;
begin
  Result := 0;
end;

function TL2Item.Grade: cardinal;
begin
  Result := 0;
end;

function TL2Item.GradeName: string;
begin
  Result := 'D';
end;

function TL2List.ByID(ID: cardinal; var Obj): boolean;
begin
  Result := False;
end;

function TL2List.ByOID(OID: cardinal; var Obj): boolean;
begin
  Result := False;
end;

function TL2List.ByName(const Name: string; var Obj): boolean;
begin
  Result := False;
end;

function TL2List.Count: integer;
begin
  Result := 0;
end;

function TL2List.Items(Index: integer): TL2Object;
begin
  Result := TL2Object.Create();
end;

function TItemList.Items(Index: integer): TL2Item; overload;
begin
  Result := TL2Item.Create();
end;

function TInventory.Pet: TItemList;
begin
  Result := TItemList.Create();
end;

function TInventory.User: TItemList;
begin
  Result := TItemList.Create();
end;

function TInventory.Quest: TItemList;
begin
  Result := TItemList.Create();
end;


function TL2AucItem.LotType: cardinal;
begin
  Result := 0;
end;

function TL2AucItem.Seller: string;
begin
  Result := '';
end;

function TL2AucItem.Price: int64;
begin
  Result := 0;
end;

function TL2AucItem.Days: cardinal;
begin
  Result := 0;
end;

function TL2AucItem.EndTime: cardinal;
begin
  Result := 0;
end;

function TAuctionList.Items(Index: integer): TL2AucItem; overload;
begin
  Result := TL2AucItem.Create();
end;

function TL2Auction.Search(const Name: string; Grade: integer = -1; PageID: integer = 0): boolean;
begin
  Result := False;
end;

function TL2Auction.SellItem(_Item: TL2Item; _Count, _Price, _Days: cardinal; _CustomName: string = ''): boolean;
begin
  Result := False;
end;

function TL2Auction.BuyItem(Item: TL2AucItem): boolean;
begin
  Result := False;
end;

function TL2Auction.GetMySales: boolean;
begin
  Result := False;
end;

function TL2Auction.CancelItem(Item: TL2AucItem): boolean;
begin
  Result := False;
end;

function TBuffList.Items(Index: integer): TL2Buff; overload;
begin
  Result := TL2Buff.Create();
end;

function TL2Spawn.X: integer;
begin
  Result := 0;
end;

function TL2Spawn.Y: integer;
begin
  Result := 0;
end;

function TL2Spawn.Z: integer;
begin
  Result := 0;
end;

function TL2Spawn.DistTo(_X: integer; _Y: integer; _Z: integer): cardinal; overload;
begin
  Result := 0;
end;

function TL2Spawn.DistTo(Obj: TL2Spawn): cardinal; overload;
begin
  Result := 0;
end;

function TL2Spawn.SpawnTime: cardinal;
begin
  Result := 0;
end;

function TL2Spawn.InRange(_X: integer; _Y: integer; _Z: integer; _Range: cardinal; _ZRange: cardinal = 250): boolean;
begin
  Result := False;
end;

function TL2Spawn.InZone: boolean;
begin
  Result := False;
end;

function TSpawnList.Items(Index: integer): TL2Spawn; overload;
begin
  Result := TL2Spawn.Create();
end;


function TL2Live.HP: cardinal;
begin
  Result := 0;
end;

function TL2Live.CurHP: cardinal;
begin
  Result := 0;
end;

function TL2Live.MaxHP: cardinal;
begin
  Result := 0;
end;

function TL2Live.MP: cardinal;
begin
  Result := 0;
end;

function TL2Live.CurMP: cardinal;
begin
  Result := 0;
end;

function TL2Live.MaxMP: cardinal;
begin
  Result := 0;
end;

function TL2Live.Exp: int64;
begin
  Result := 0;
end;

function TL2Live.Exp2: int64;
begin
  Result := 0;
end;

function TL2Live.SP: cardinal;
begin
  Result := 0;
end;

function TL2Live.PK: boolean;
begin
  Result := False;
end;

function TL2Live.PvP: boolean;
begin
  Result := False;
end;

function TL2Live.Karma: integer;
begin
  Result := 0;
end;

function TL2Live.Load: cardinal;
begin
  Result := 0;
end;

function TL2Live.Level: byte;
begin
  Result := 0;
end;

function TL2Live.Title: string;
begin
  Result := '';
end;

function TL2Live.Speed: double;
begin
  Result := 0;
end;

function TL2Live.Running: boolean;
begin
  Result := False;
end;

function TL2Live.Sitting: boolean;
begin
  Result := False;
end;

function TL2Live.Fishing: integer;
begin
  Result := 0;
end;

function TL2Live.Fly: boolean;
begin
  Result := False;
end;

function TL2Live.Dead: boolean;
begin
  Result := False;
end;

function TL2Live.Dropped: boolean;
begin
  Result := False;
end;

function TL2Live.Sweepable: boolean;
begin
  Result := False;
end;

function TL2Live.Clan: string;
begin
  Result := '';
end;

function TL2Live.ClanID: cardinal;
begin
  Result := 0;
end;

function TL2Live.Ally: string;
begin
  Result := '';
end;

function TL2Live.AllyID: cardinal;
begin
  Result := 0;
end;

function TL2Live.Attackable: boolean;
begin
  Result := False;
end;

function TL2Live.AtkOID: cardinal;
begin
  Result := 0;
end;

function TL2Live.AtkTime: cardinal;
begin
  Result := 0;
end;

function TL2Live.MyAtkTime: cardinal;
begin
  Result := 0;
end;

function TL2Live.InCombat: boolean;
begin
  Result := False;
end;

function TL2Live.Buffs: TBuffList;
begin
  Result := TBuffList.Create();
end;

function TL2Live.Cast: TL2Cast;
begin
  Result := TL2Cast.Create();
end;

function TL2Live.Target: TL2Live;
begin
  Result := TL2Live.Create();
end;

function TL2Live.IsMember: boolean;
begin
  Result := False;
end;

function TL2Live.Team: byte;
begin
  Result := 0;
end;

function TL2Live.TeleportDist: cardinal;
begin
  Result := 0;
end;

function TL2Live.TeleportTime: cardinal;
begin
  Result := 0;
end;

function TL2Live.AbnormalID: cardinal;
begin
  Result := 0;
end;

function TL2Live.Abnormals: TBuffList;
begin
  Result := TBuffList.Create();
end;

function TL2Live.ToX: integer;
begin
  Result := 0;
end;

function TL2Live.ToY: integer;
begin
  Result := 0;
end;

function TL2Live.ToZ: integer;
begin
  Result := 0;
end;


function TL2Char.CP: cardinal;
begin
  Result := 0;
end;

function TL2Char.CurCP: cardinal;
begin
  Result := 0;
end;

function TL2Char.MaxCP: cardinal;
begin
  Result := 0;
end;

function TL2Char.Hero: boolean;
begin
  Result := False;
end;

function TL2Char.Noble: boolean;
begin
  Result := False;
end;

function TL2Char.ClassID: cardinal;
begin
  Result := 0;
end;

function TL2Char.MainClass: cardinal;
begin
  Result := 0;
end;

function TL2Char.MountType: byte;
begin
  Result := 0;
end;

function TL2Char.StoreType: byte;
begin
  Result := 0;
end;

function TL2Char.Sex: cardinal;
begin
  Result := 0;
end;

function TL2Char.Race: cardinal;
begin
  Result := 0;
end;

function TL2Char.CubicCount: cardinal;
begin
  Result := 0;
end;

function TL2Char.Recom: cardinal;
begin
  Result := 0;
end;

function TL2Char.Premium: boolean;
begin
  Result := False;
end;

function TL2Char.L2Class: TL2Class;
begin
  Result := TL2Class.lcBuff;
end;

function TCharList.Items(Index: integer): TL2Char; overload;
begin
  Result := TL2Char.Create();
end;

function TL2Drop.Count: int64;
begin
  Result := 0;
end;

function TL2Drop.IsMy: boolean;
begin
  Result := False;
end;

function TL2Drop.Stackable: boolean;
begin
  Result := False;
end;

function TDropList.Items(Index: integer): TL2Drop; overload;
begin
  Result := TL2Drop.Create();
end;

function TL2Npc.IsPet: boolean;
begin
  Result := False;
end;

function TL2Npc.PetType: cardinal;
begin
  Result := 0;
end;

function TNpcList.Items(Index: integer): TL2Npc; overload;
begin
  Result := TL2Npc.Create();
end;

function TL2Pet.Fed: cardinal;
begin
  Result := 0;
end;

function TPetList.Items(Index: integer): TL2Pet; overload;
begin
  Result := TL2Pet.Create();
end;

procedure TL2Script.Stop;
begin
  NOP;
end;

procedure TL2Script.Pause;
begin
  NOP;
end;

procedure TL2Script.Suspend;
begin
  NOP;
end;

procedure TL2Script.Resume;
begin
  NOP;
end;

procedure TL2Script.NewThread(Address: Pointer);
begin
  NOP;
end;

function TL2Script.Replace(const Name: string = ''): boolean;
begin
  Result := False;
end;

function TL2Script.Path: string;
begin
  Result := '';
end;

procedure TL2Script.MainProc(Proc: Pointer);
begin
  NOP;
end;

function TL2Script.StartPlugin(const PluginName: string; PProc: Pointer; ShowModal: boolean): boolean;
begin
  Result := False;
end;

function TL2Script.OnPluginProc(Code: cardinal; p1: WideString): integer;
begin
  Result := 0;
end;

function TL2Skill.Disabled: boolean;
begin
  Result := False;
end;

function TL2Skill.Enchanted: boolean;
begin
  Result := False;
end;

function TL2Skill.Passive: boolean;
begin
  Result := False;
end;

function TSkillList.Items(Index: integer): TL2Skill; overload;
begin
  Result := TL2Skill.Create();
end;

function TL2User.CanCryst: boolean;
begin
  Result := False;
end;

function TL2User.Charges: cardinal;
begin
  Result := 0;
end;

function TL2User.WeightPenalty: cardinal;
begin
  Result := 0;
end;

function TL2User.WeapPenalty: cardinal;
begin
  Result := 0;
end;

function TL2User.ArmorPenalty: cardinal;
begin
  Result := 0;
end;

function TL2User.DeathPenalty: cardinal;
begin
  Result := 0;
end;

function TL2User.Souls: cardinal;
begin
  Result := 0;
end;

function TL2WareHouse.Items(Index: integer): TL2Item;
begin
  Result := TL2Item.Create();
end;

function TParty.Pets: TNpcList;
begin
  Result := TNpcList.Create();
end;

function TParty.Chars: TCharList;
begin
  Result := TCharList.Create();
end;

function TParty.LootType: TLootType;
begin
  Result := TLootType.ldLooter;
end;

function TParty.Leader: TL2Char;
begin
  Result := TL2Char.Create();
end;


function TConfirmDlg.MsgID: cardinal;
begin
  Result := 0;
end;

function TConfirmDlg.ReqID: cardinal;
begin
  Result := 0;
end;

function TConfirmDlg.Sender: string;
begin
  Result := '';
end;

function TConfirmDlg.EndTime: cardinal;
begin
  Result := 0;
end;

function TConfirmDlg.Valid: boolean;
begin
  Result := False;
end;


function TL2Control.MoveTo(X, Y, Z: integer; const TimeOut: integer = 8000): boolean; overload;
begin
  Result := False;
end;

function TL2Control.MoveTo(Obj: TL2Spawn; Dist: integer): boolean; overload;
begin
  Result := False;
end;

function TL2Control.DMoveTo(x, y, z: integer): boolean;
begin
  Result := False;
end;

function TL2Control.MoveToTarget(Dist: integer = -100): boolean;
begin
  Result := False;
end;

function TL2Control.AuctionBuyItem(Item: TL2AucItem): boolean;
begin
  Result := False;
end;

function TL2Control.AuctionCancelItem(Item: TL2AucItem): boolean;
begin
  Result := False;
end;

function TL2Control.AuctionGetMySales: boolean;
begin
  Result := False;
end;

function TL2Control.AuctionSearch(const Name: string; Grade: integer = -1; PageID: integer = 0): boolean;
begin
  Result := False;
end;

function TL2Control.AuctionSellItem(Item: TL2Item; Count, Price, Days: cardinal; CustomName: string = ''): boolean;
begin
  Result := False;
end;

function TL2Control.Assist(const Name: string): boolean;
begin
  Result := False;
end;

function TL2Control.Attack(TimeOut: cardinal = 2000; Ctrl: boolean = False): boolean;
begin
  Result := False;
end;

function TL2Control.AutoSoulShot(const Name: string; Active: boolean): boolean;
begin
  Result := False;
end;

function TL2Control.AutoTarget(Range: cardinal = 2000; ZRange: cardinal = 300; NotBusy: boolean = True): boolean;
begin
  Result := False;
end;

function TL2Control.FindEnemy(var Enemy: TL2Live; Obj: TL2Live; Range: cardinal = 2000; ZRange: cardinal = 300): boolean;
begin
  Result := False;
end;

function TL2Control.SetTarget(const Name: string): boolean; overload;
begin
  Result := False;
end;

function TL2Control.SetTarget(ID: cardinal): boolean; overload;
begin
  Result := False;
end;

function TL2Control.SetTarget(Obj: TL2Live): boolean; overload;
begin
  Result := False;
end;

function TL2Control.CancelTarget: boolean;
begin
  Result := False;
end;

function TL2Control.PickUp(Obj: TL2Drop; Pet: boolean = False): boolean; overload;
begin
  Result := False;
end;

function TL2Control.PickUp(Range: cardinal = 250; ZRange: cardinal = 150; OnlyMy: boolean = False; Pet: boolean = False): integer; overload;
begin
  Result := 0;
end;

function TL2Control.FaceControl(ID: integer; Active: boolean): boolean;
begin
  Result := False;
end;

function TL2Control.LoadConfig(const Name: string): boolean;
begin
  Result := False;
end;

function TL2Control.LoadZone(const Name: string): boolean;
begin
  Result := False;
end;

procedure TL2Control.ClearZone;
begin
  NOP;
end;

procedure TL2Control.Ignore(Obj: TL2Spawn);
begin
  NOP;
end;

procedure TL2Control.ClearIgnore;
begin
  NOP;
end;

function TL2Control.InZone(Obj: TL2Spawn): boolean; overload;
begin
  Result := False;
end;

function TL2Control.InZone(X, Y, Z: integer): boolean; overload;
begin
  Result := False;
end;

function TL2Control.BlinkWindow(GameWindow: boolean): boolean;
begin
  Result := False;
end;

function TL2Control.BotWindow: cardinal;
begin
  Result := 0;
end;

function TL2Control.GameWindow: cardinal;
begin
  Result := 0;
end;

function TL2Control.GameStart(CharIndex: integer = -1): boolean;
begin
  Result := False;
end;

function TL2Control.Restart: boolean;
begin
  Result := False;
end;

function TL2Control.GameClose: boolean;
begin
  Result := False;
end;

function TL2Control.PostMessage(Msg: cardinal; wParam, lParam: integer): integer;
begin
  Result := 0;
end;

function TL2Control.SendMessage(Msg: cardinal; wParam, lParam: integer): integer;
begin
  Result := 0;
end;

function TL2Control.SetGameWindow(Visible: boolean): boolean;
begin
  Result := False;
end;

procedure TL2Control.SetMapKeepDist(Value: integer);
begin
  NOP;
end;

function TL2Control.GoHome(ResType: TRestartType = rtTown): boolean;
begin
  Result := False;
end;

function TL2Control.GameTime: cardinal;
begin
  Result := 0;
end;

function TL2Control.ServerTime: cardinal;
begin
  Result := 0;
end;

function TL2Control.Status: TL2Status;
begin
  Result := TL2Status.lsOff;
end;

function TL2Control.WaitAction(Actions: TL2Actions; var P1; var P2; TimeOut: cardinal = High(cardinal)): TL2Actions;
begin
  Result := TL2Actions.atTeleport;
end;

function TL2Control.EnterText(const Txt: string): boolean;
begin
  Result := False;
end;

function TL2Control.Say(const Text: string; ChatType: cardinal = 0; const Nick: string = ''): boolean;
begin
  Result := False;
end;

function TL2Control.UseKey(const Key: string; Ctrl: boolean = False; Shift: boolean = False): boolean; overload;
begin
  Result := False;
end;

function TL2Control.UseKey(Key: word; Ctrl: boolean = False; Shift: boolean = False): boolean; overload;
begin
  Result := False;
end;

function TL2Control.Entry(var Param): boolean;
begin
  Result := False;
end;

function TL2Control.FindPath(StartX, StartY, EndX, EndY: integer; PathList: TList): boolean;
begin
  Result := False;
end;

procedure TL2Control.Msg(Who, What: string; Color: integer);
begin
  NOP;
end;

function TL2Control.IsBusy(Obj: TL2Npc): boolean;
begin
  Result := False;
end;

function TL2Control.IsDay: boolean;
begin
  Result := False;
end;

function TL2Control.KickMentor: boolean;
begin
  Result := False;
end;

function TL2Control.GetMentor: string;
begin
  Result := '';
end;

function TL2Control.InviteParty(const Name: string; Loot: TLootType = ldLooter): boolean;
begin
  Result := False;
end;

function TL2Control.DismissParty(const Name: string): boolean;
begin
  Result := False;
end;

function TL2Control.JoinParty(Join: boolean): boolean;
begin
  Result := False;
end;

function TL2Control.LeaveParty: boolean;
begin
  Result := False;
end;

function TL2Control.SetPartyLeader(const Name: string): boolean;
begin
  Result := False;
end;

function TL2Control.DismissPet: boolean;
begin
  Result := False;
end;

function TL2Control.DismissSum: boolean;
begin
  Result := False;
end;

function TL2Control.DlgOpen: boolean;
begin
  Result := False;
end;

function TL2Control.DlgSel(const Txt: string; const TimeOut: integer = 1000): boolean; overload;
begin
  Result := False;
end;

function TL2Control.DlgSel(Index: integer; const TimeOut: integer = 1000): boolean; overload;
begin
  Result := False;
end;

function TL2Control.DlgText: string;
begin
  Result := '';
end;

function TL2Control.ConfirmDialog(Accept: boolean): boolean;
begin
  Result := False;
end;

function TL2Control.ConfirmDlg: TConfirmDlg;
begin
  Result := TConfirmDlg.Create();
end;

function TL2Control.BypassToServer(const S: string): boolean;
begin
  Result := False;
end;

procedure TL2Control.AutoAcceptMentors(Names: string);
begin
  NOP;
end;

procedure TL2Control.AutoAcceptClan(Names: string);
begin
  NOP;
end;

procedure TL2Control.AutoAcceptCC(Names: string);
begin
  NOP;
end;

function TL2Control.UseSkill(const Name: string; Ctrl: boolean = False; Shift: boolean = False): boolean; overload;
begin
  Result := False;
end;

function TL2Control.UseSkill(ID: cardinal; Ctrl: boolean = False; Shift: boolean = False): boolean; overload;
begin
  Result := False;
end;

function TL2Control.DUseSkill(ID: cardinal; Ctrl, Shift: boolean): boolean;
begin
  Result := False;
end;

function TL2Control.StopCasting: boolean;
begin
  Result := False;
end;

function TL2Control.Dispel(const Name: string): boolean;
begin
  Result := False;
end;

function TL2Control.LearnSkill(ID: cardinal): boolean;
begin
  Result := False;
end;

function TL2Control.UpdateSkillList: boolean;
begin
  Result := False;
end;

function TL2Control.UseSkillGround(ID: cardinal; X, Y, Z: integer; Ctrl: boolean = False; Shift: boolean = False): boolean;
begin
  Result := False;
end;

function TL2Control.NpcExchange(ID: cardinal; Count: cardinal): boolean;
begin
  Result := False;
end;

function TL2Control.NpcTrade(Sell: boolean; Items: array of cardinal): boolean;
begin
  Result := False;
end;

function TL2Control.CastleTax(TownID: cardinal): integer;
begin
  Result := 0;
end;

function TL2Control.OpenQuestion: boolean;
begin
  Result := False;
end;

function TL2Control.QuestStatus(QuestID: cardinal; Step: integer): boolean;
begin
  Result := False;
end;

function TL2Control.CancelQuest(ID: integer): boolean;
begin
  Result := False;
end;

function TL2Control.GetDailyItems: boolean;
begin
  Result := False;
end;

function TL2Control.GetCharList: TCharList;
begin
  Result := TCharList.Create();
end;

function TL2Control.GetDropList: TDropList;
begin
  Result := TDropList.Create();
end;

function TL2Control.GetInventory: TInventory;
begin
  Result := TInventory.Create();
end;

function TL2Control.GetNpcList: TNpcList;
begin
  Result := TNpcList.Create();
end;

function TL2Control.GetParty: TParty;
begin
  Result := TParty.Create();
end;

function TL2Control.GetPetList: TPetList;
begin
  Result := TPetList.Create();
end;

function TL2Control.GetSkillList: TSkillList;
begin
  Result := TSkillList.Create();
end;

function TL2Control.GetUser: TL2User;
begin
  Result := TL2User.Create();
end;

function TL2Control.GetFaceState(ID: integer): boolean;
begin
  Result := False;
end;

function TL2Control.UseItem(const Name: string; Pet: boolean = False): boolean; overload;
begin
  Result := False;
end;

function TL2Control.UseItem(ID: cardinal; Pet: boolean = False): boolean; overload;
begin
  Result := False;
end;

function TL2Control.UseItem(Obj: TL2Item; Pet: boolean = False): boolean; overload;
begin
  Result := False;
end;

function TL2Control.LoadItems(ToWH: boolean; Items: array of cardinal): boolean;
begin
  Result := False;
end;

function TL2Control.MoveItem(const Name: string; Count: cardinal; ToPet: boolean): boolean;
begin
  Result := False;
end;

function TL2Control.Equipped(const Name: string): integer;
begin
  Result := 0;
end;

function TL2Control.MakeItem(Index: cardinal): boolean;
begin
  Result := False;
end;

function TL2Control.CrystalItem(ID: cardinal): boolean;
begin
  Result := False;
end;

function TL2Control.DestroyItem(const Name: string; Count: cardinal): boolean; overload;
begin
  Result := False;
end;

function TL2Control.DestroyItem(ID: integer; Count: cardinal): boolean; overload;
begin
  Result := False;
end;

function TL2Control.UseAction(ID: cardinal; Ctrl: boolean = False; Shift: boolean = False): boolean;
begin
  Result := False;
end;

function TL2Control.Sit: boolean;
begin
  Result := False;
end;

function TL2Control.Stand: boolean;
begin
  Result := False;
end;

function TL2Control.Unstuck: boolean;
begin
  Result := False;
end;

function TL2Control.CreateRoom(Text: string; LevelStart, LevelEnd: integer): boolean;
begin
  Result := False;
end;

function TL2Control.CloseRoom: boolean;
begin
  Result := False;
end;

function TL2Control.OpenPrivateStore(PriceList: array of cardinal; StoreType: byte; StoreMsg: string): boolean;
begin
  Result := False;
end;

function TL2Control.SendMail(const Recipient: string; const Theme: string; const Content: string; Items: array of cardinal; Price: cardinal = 0): boolean;
begin
  Result := False;
end;

function TL2Control.GetMailItems(MaxLoad: cardinal = 65; MaxCount: cardinal = 1000): boolean;
begin
  Result := False;
end;

function TL2Control.ClearMail: boolean;
begin
  Result := False;
end;

function TGps.Count: integer;
begin
  Result := 0;
end;

function TGps.LoadBase(const FilePath: string): integer;
begin
  Result := 0;
end;

function TGps.GetPath(X1, Y1, Z1, X2, Y2, Z2: single): integer;
begin
  Result := 0;
end;

function TGps.GetPathByName(X1, Y1, Z1: single; PointName: string): integer;
begin
  Result := 0;
end;

function TGps.Items(Index: integer): TGpsPoint;
begin
  Result := TGpsPoint.Create();
end;

//!!! Реализация глобальных функций/процедур !!!
function Delay(ms: cardinal): boolean;
begin
  Result := False;
end;

procedure PlaySound(const FileName: string; Loop: boolean = False);
begin
  NOP;
end;

procedure StopSound;
begin
  NOP;
end;

function ExePath: string;
begin
  Result := '';
end;

function TimerEx(var Value: cardinal; Delay: cardinal): boolean;
begin
  Result := False;
end;

function GetHWID: cardinal;
begin
  Result := 0;
end;

function BotLoginID: cardinal;
begin
  Result := 0;
end;

function GetControl(Nick: string): TL2Control;
begin
  Result := TL2Control.Create();
end;

function GetControlByIndex(Index: integer): TL2Control;
begin
  Result := TL2Control.Create();
end;

procedure OnMoveEvent(Attacker: TL2Live; var BreakMove: boolean);
begin
  NOP;
end;

function OnEntry(var Param): boolean;
begin
  Result := False;
end;

procedure OnFree;
begin
  NOP;
end;

function FToStr(Value: single): string;
begin
  Result := '';
end;

function MemToHex(const dt; size: word; sep: char = #0): string; overload;
begin
  Result := '';
end;

function MemToHex(const Mem: ansistring): string; overload;
begin
  Result := '';
end;

function HexToMem(const Hex: string; var Buf): cardinal; overload;
begin
  Result := 0;
end;

function HexToMem(const Hex: string): ansistring; overload;
begin
  Result := '';
end;

procedure Print(const msg: Variant);
begin

end;

begin
end.
