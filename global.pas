unit Global;

interface

uses
  Classes, SysUtils;

type
  //Перечисления
  TL2Status = (
    lsOff,    //Отключен
    lsOnline, //Онлайн
    lsOffline //Оффлайн
    );

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

  TL2Actions = (
    laSpawn, //появление в игровом мире (респ)
    laDelete, //исчезание из игрового мира
    laPetSpawn, //появление пета в игровом мире (респ)
    laPetDelete, //исчезание пета из игрового мира
    laInvite, //приглашение в пати
    laDie, //смерть
    laRevive, //воскрешение
    laTarget, //взяли в таргет
    laUnTarget, //отменили таргет
    laInGame, //в игре
    laStatus, //изменение статуса аккаунта
    laBuffs, //наложение бафа
    laSkills, //применение умений
    laDlg, //выбор диалога
    laConfirmDlg, //подтверждение диалога
    laStop, //остановка
    laStartAttack, //начало боя
    laStopAttack, //прекращение боя
    laCast, //начало каста
    laCancelCast, //отмена каста
    laTeleport, //телепортация
    laAutoSoulShot, //вкл\выкл автоиспользования сосок
    atTeleport, //телепорт
    laNpcTrade, //проведение сделки с торговцем
    laSysMsg, //системное сообщение
    laKey //нажатие кнопки
    );


  TLootType = (
    ldLooter,      //Нашедшому
    ldRandom,      //Случайно
    ldRandomSpoil, //Случайно + присвоить
    ldOrder,       //По очереди
    ldOrderSpoil   //По очереди + присвоить
    );


  TStoreType = (
    stNone, //отсутствует
    stSell, //продажа
    stPrepareSell, //производит настройки продажи
    stBuy,  //покупка
    stPrepareBuy, //производит настройки покупки
    stManufacture, //крафт
    stPrepareManufacture, //производит настройки крафта
    stObservingGames, //смотрит игры
    stSellPackage //продает пачкой
    );

  TRestartType = (
    rtTown,     //в город
    rtClanHoll, //в клан хол
    rtCastle,   //в замок
    rtFort,     //в форт
    rtFlags     //к флагу
    );

  TMessageType = (
    mtSystem,  //системное
    mtAll,     //общий чат
    mtPrivate, //приватный чат
    mtParty,   //пати чат
    mtClan,    //клановый чат
    mtFriend,  //переписка с другом
    mtShout    //крик
    );

implementation

begin
end.
