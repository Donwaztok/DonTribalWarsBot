program DonTribalWarsBot;

uses
  Vcl.Forms,
  cVillage in 'Class\cVillage.pas',
  cMap in 'Class\cMap.pas',
  uClient in 'Forms\uClient.pas' {Client},
  cImageMap in 'Class\cImageMap.pas',
  cImageBuffer in 'Class\cImageBuffer.pas',
  cImageBuffered in 'Class\cImageBuffered.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TClient, Client);
  Application.Run;
end.
