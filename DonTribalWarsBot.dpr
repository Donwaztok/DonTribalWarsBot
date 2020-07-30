program DonTribalWarsBot;

uses
  Vcl.Forms,
  uClient in 'lib\Forms\uClient.pas' {Client},
  cImageBuffer in 'lib\Class\cImageBuffer.pas',
  cImageBuffered in 'lib\Class\cImageBuffered.pas',
  cImageMap in 'lib\Class\cImageMap.pas',
  cMap in 'lib\Class\cMap.pas',
  cVillage in 'lib\Class\cVillage.pas',
  Action in 'lib\Interfaces\Action.pas',
  cScavenge in 'lib\Class\Actions\cScavenge.pas',
  cActions in 'lib\Class\cActions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TClient, Client);
  Application.Run;
end.
