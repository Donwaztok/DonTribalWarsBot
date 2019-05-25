unit cImageBuffered;

interface

uses Vcl.Graphics;

type TImageBuffered = class
Protected
  FImageBuffered :TPicture;
  FName :String;
Public
  property Name  :String read FName write FName;
  property Image :TPicture read FImageBuffered write FImageBuffered;
  Constructor Create(N :String);
end;

implementation

uses uClient,SysUtils,Forms,Dialogs;

Constructor TImageBuffered.Create(N :String);
begin
  FImageBuffered := TPicture.Create;
  FName:=N;
  FImageBuffered.LoadFromFile(ExtractFilePath(Application.ExeName)+'Texture\'+FName+'.png');
end;

end.
