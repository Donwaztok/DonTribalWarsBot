unit cImageBuffer;

interface

uses cImageBuffered,Graphics;

type TImageBuffer = class
Protected
  FImageBuffer :Array of TImageBuffered;
Public
  //property Image[n :String] :TImage read GetImage; default;
  function GetImage(n :String): TPicture;
  Constructor Create();
end;

implementation
uses SysUtils,Forms,Dialogs;
Constructor TImageBuffer.Create();
begin
  SetLength(FImageBuffer,28);
  //Player Bonus
  FImageBuffer[0] := TImageBuffered.Create('b1');
  FImageBuffer[1] := TImageBuffered.Create('b2');
  FImageBuffer[2] := TImageBuffered.Create('b3');
  FImageBuffer[3] := TImageBuffered.Create('b4');
  FImageBuffer[4] := TImageBuffered.Create('b5');
  FImageBuffer[5] := TImageBuffered.Create('b6');
  //Left Bonus
  FImageBuffer[6] := TImageBuffered.Create('b1_left');
  FImageBuffer[7] := TImageBuffered.Create('b2_left');
  FImageBuffer[8] := TImageBuffered.Create('b3_left');
  FImageBuffer[9] := TImageBuffered.Create('b4_left');
  FImageBuffer[10]:= TImageBuffered.Create('b5_left');
  FImageBuffer[11]:= TImageBuffered.Create('b6_left');
  //Player Village
  FImageBuffer[12]:= TImageBuffered.Create('v1');
  FImageBuffer[13]:= TImageBuffered.Create('v2');
  FImageBuffer[14]:= TImageBuffered.Create('v3');
  FImageBuffer[15]:= TImageBuffered.Create('v4');
  FImageBuffer[16]:= TImageBuffered.Create('v5');
  FImageBuffer[17]:= TImageBuffered.Create('v6');
  //Left Villege
  FImageBuffer[18]:= TImageBuffered.Create('v1_left');
  FImageBuffer[19]:= TImageBuffered.Create('v2_left');
  FImageBuffer[20]:= TImageBuffered.Create('v3_left');
  FImageBuffer[21]:= TImageBuffered.Create('v4_left');
  FImageBuffer[22]:= TImageBuffered.Create('v5_left');
  FImageBuffer[23]:= TImageBuffered.Create('v6_left');
  //Grass
  FImageBuffer[24]:= TImageBuffered.Create('gras1');
  FImageBuffer[25]:= TImageBuffered.Create('gras2');
  FImageBuffer[26]:= TImageBuffered.Create('gras3');
  FImageBuffer[27]:= TImageBuffered.Create('gras4');
end;

function TImageBuffer.GetImage(n :String): TPicture;
var I :Integer;
begin
  for I := Low(FImageBuffer) to High(FImageBuffer) do
    if FImageBuffer[I].Name=n then result := FImageBuffer[I].Image;
end;
end.
