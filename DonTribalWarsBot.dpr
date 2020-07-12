program DonTribalWarsBot;

uses
  Vcl.Forms,
  uClient in 'lib\Forms\uClient.pas' {Client},
  cImageBuffer in 'lib\Class\cImageBuffer.pas',
  cImageBuffered in 'lib\Class\cImageBuffered.pas',
  cImageMap in 'lib\Class\cImageMap.pas',
  cMap in 'lib\Class\cMap.pas',
  cVillage in 'lib\Class\cVillage.pas',
  iAction in 'lib\Interfaces\iAction.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TClient, Client);
  Application.Run;
end.
