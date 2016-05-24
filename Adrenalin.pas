unit Adrenalin;

interface

uses
  Classes, SysUtils, Global, ConfirmDlg, L2AucItem, L2Auction, L2Buff,
  L2Cast, L2Char, L2Control, L2Drop, L2Effect, L2Item, L2List, L2Live,
  L2Npc, L2Object, L2Pet, L2Script, L2Skill, L2Spawn, L2User, L2WareHouse,
  Party, ChatMessage, Gps, GpsPoint, Inventory;

type
  //Служебные
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
procedure Print(data);

implementation

begin
end.
