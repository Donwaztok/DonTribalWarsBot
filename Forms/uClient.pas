unit uClient;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Registry, Vcl.OleCtrls, StrUtils,
  SHDocVw, Vcl.ExtCtrls, Vcl.Imaging.pngimage, Vcl.ComCtrls, URLMon,
  //Class
  cVillage, cMap, cImageMap;

type
  TClient = class(TForm)
    Timer1: TTimer;
    Image_Iron: TImage;
    Image_Stone: TImage;
    Image_Wood: TImage;
    Image_Ressources: TImage;
    Image_Population: TImage;
    Label_Iron: TLabel;
    Label_Stone: TLabel;
    Label_Wood: TLabel;
    Label_Ressources: TLabel;
    Label_Population: TLabel;
    Label_ServerTime: TLabel;
    Image1: TImage;
    Label1: TLabel;
    PageControl1: TPageControl;
    Tab: TTabSheet;
    TabSheet2: TTabSheet;
    MapBox: TScrollBox;
    MainBrowser: TWebBrowser;
    ScrollBox1: TScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    //Vars
    wood,stone,iron,storage,pop_cur,pop_max :integer;
    server_time:string;
    ImageMap :TImageMap;
    //Functions
    procedure UpdateVillage();
    procedure GetRessources();
  public
    { Public declarations }
    //Vars
    Map :TMap;
    //Move Image
    MouseDownSpot : TPoint;
    Capturing : bool;
  end;

var
  Client: TClient;

implementation

{$R *.dfm}

//==============================================================================
//==============================================================================
//== Application Version =======================================================
Function VersaoExe: String;
type
   PFFI = ^vs_FixedFileInfo;
var
   F       : PFFI;
   Handle  : Dword;
   Len     : Longint;
   Data    : Pchar;
   Buffer  : Pointer;
   Tamanho : Dword;
   Parquivo: Pchar;
   Arquivo : String;
begin
   Arquivo  := Application.ExeName;
   Parquivo := StrAlloc(Length(Arquivo) + 1);
   StrPcopy(Parquivo, Arquivo);
   Len := GetFileVersionInfoSize(Parquivo, Handle);
   Result := '';
   if Len > 0 then
   begin
      Data:=StrAlloc(Len+1);
      if GetFileVersionInfo(Parquivo,Handle,Len,Data) then
      begin
         VerQueryValue(Data, '',Buffer,Tamanho);
         F := PFFI(Buffer);
         Result := Format('%d.%d.%d.%d',
                          [HiWord(F^.dwFileVersionMs),
                           LoWord(F^.dwFileVersionMs),
                           HiWord(F^.dwFileVersionLs),
                           Loword(F^.dwFileVersionLs)]
                         );
      end;
      StrDispose(Data);
   end;
   StrDispose(Parquivo);
end;
//=== Split Function ===========================================================
procedure Split(Line: String; List: TStringList);
begin
List.Clear;
ExtractStrings([','],[],PChar(Line),List);
end;
//=== Update Ressources ========================================================
procedure TClient.FormResize(Sender: TObject);
begin
ImageMap:= TImageMap.Create;
end;

procedure TClient.GetRessources();
begin
if (MainBrowser.ReadyState=READYSTATE_COMPLETE)  then
  begin
    //Wood
    try wood:=MainBrowser.OleObject.Document.getElementById('wood').InnerText;
    except wood:=0; end;
    //Stone
    try stone:=MainBrowser.OleObject.Document.getElementById('stone').InnerText;
    except stone:=0; end;
    //Iron
    try iron:=MainBrowser.OleObject.Document.getElementById('iron').InnerText;
    except iron:=0; end;
    //Storage
    try storage:=MainBrowser.OleObject.Document.getElementById('storage').InnerText;
    except storage:=0; end;
    //Current Population
    try pop_cur:=MainBrowser.OleObject.Document.getElementById('pop_current_label').InnerText;
    except pop_cur:=0; end;
    //Max Population
    try pop_max:=MainBrowser.OleObject.Document.getElementById('pop_max_label').InnerText;
    except pop_max:=0; end;
    //Server Time
    try server_time:=MainBrowser.OleObject.Document.getElementById('serverTime').InnerText;
    except server_time:='00:00:00'; end;

    Label_Wood.Caption:=IntToStr(wood);
    Label_Stone.Caption:=IntToStr(stone);
    Label_Iron.Caption:=IntToStr(iron);
    Label_Ressources.Caption:=IntToStr(storage);
    Label_Population.Caption:=IntToStr(pop_cur)+'/'+IntToStr(pop_max);
    Label_ServerTime.Caption:=server_time;
  end;
end;
//=== Move Map =================================================================
procedure TClient.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
Capturing := true;
MouseDownSpot.X := x;
MouseDownSpot.Y := Y;
end;
procedure TClient.MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
if Capturing then
  begin
    ImageMap[0,0].Left:= ImageMap[0,0].Left-(MouseDownSpot.x-x);
    ImageMap[0,0].Top := ImageMap[0,0].Top -(MouseDownSpot.y-y);
    Label1.Caption:='X: '+IntToStr(ImageMap.PosX)+' | Y: '+IntToStr(ImageMap.PosY);
    ImageMap.Arrange;
  end;
end;
procedure TClient.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if Capturing then
  begin
    ReleaseCapture;
    Capturing := false;
    ImageMap[0,0].Left:= ImageMap[0,0].Left-(MouseDownSpot.x-x);
    ImageMap[0,0].Top := ImageMap[0,0].Top -(MouseDownSpot.y-y);
    ImageMap.Arrange;
  end;
end;
//=== Update Village Function ==================================================
procedure TClient.UpdateVillage;
var I:Integer;
    VillageLines :TStringList;
    Memo :TMemo;
begin
  {if (FileDateToDateTime(FileAge(ExtractFilePath(Application.ExeName)+'Data/village.txt'))) <
  (Now-(5/24)) then
  URLDownloadToFile(nil,'https://br86.tribalwars.com.br/map/village.txt',
                    PChar(ExtractFilePath(Application.ExeName)+'Data/village.txt'),0,nil);  }

  Memo:=TMemo.Create(Self);
  Memo.Parent:=Client;
  Memo.Width:=1000;

  VillageLines:= TStringList.Create;

  Memo.Clear;
  Memo.Lines.LoadFromFile(ExtractFilePath(Application.ExeName)+'Data/village.txt');
  for i:=0 to Memo.Lines.Count-1 do
    begin
      Split(Memo.Lines[I],VillageLines);
      Map[StrToInt(VillageLines[2]),StrToInt(VillageLines[3])]:=
                    Tvillage.Create(StrToInt(VillageLines[0]),
                                             VillageLines[1] ,
                                    StrToInt(VillageLines[2]),
                                    StrToInt(VillageLines[3]),
                                    StrToInt(VillageLines[4]),
                                    StrToInt(VillageLines[5]),
                                    StrToInt(VillageLines[6])
                                    );
      Application.ProcessMessages;
    end;
  Memo.Clear;
  Memo.Free;
end;
//==============================================================================
//==============================================================================
//==============================================================================
//=== End of Functions =========================================================
//==============================================================================
//==============================================================================
//==============================================================================
//=== Form Creation ============================================================
procedure TClient.FormCreate(Sender: TObject);
var reg: TRegistry;
begin
//IE11
reg := TRegistry.Create;
reg.RootKey:=HKEY_CURRENT_USER;
reg.OpenKey('\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION',True);
if not reg.ValueExists(ExtractFileName(Application.ExeName)) then
  begin
    reg.WriteInteger(ExtractFileName(Application.ExeName),11001);
    ShowMessage('Browser configured. Please, restart the aplication!');
  end;
reg.CloseKey();
reg.Free;
//Variables
wood:=0;iron:=0;stone:=0;storage:=0;pop_cur:=0;pop_max:=0;
//Browser
//WebBrowser1.Navigate2('www.tribalwars.com.br');
//Map
Map := TMap.Create;
//Initial Villages
UpdateVillage;
//Etc
Client.DoubleBuffered:=True;
MapBox.DoubleBuffered:=True;
ImageMap := TImageMap.Create;
end;
//=== Timer ====================================================================
procedure TClient.Timer1Timer(Sender: TObject);
begin
//GetRessources;
end;
//==============================================================================
end.
