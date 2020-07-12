unit cImageMap;

interface

uses ExtCtrls,StdCtrls,cMap,cImageBuffer;

type TImageMap = class
//=== Protected ================================================================
Protected
  FQtdX        :Integer;
  FQtdY        :Integer;
  FPosX        :Integer;
  FPosY        :Integer;
  FWidth       :Integer;
  FHeight      :Integer;
  FImageBuffer :TImageBuffer;
  FImageMap    :Array of Array of TImage;
  FLabelCoordX :Array of TLabel;
  FLabelCoordY :Array of TLabel;
  function   GetMap(x :Integer; y :Integer): TImage;
  procedure  SetMap(x :Integer; y :Integer; Image :TImage);
//=== Public ===================================================================
Public
  Property QtdX  :Integer read FQtdX   write FQtdX;
  Property QtdY  :Integer read FQtdY   write FQtdY;
  Property PosX  :Integer read FPosX   write FPosX;
  Property PosY  :Integer read FPosY   write FPosY;
  Property W     :Integer read FWidth  write FWidth;
  Property H     :Integer read FHeight write FHeight;
  property Map[x :Integer; y :Integer] :TImage read GetMap write SetMap; default;
  Constructor Create();
  Procedure Make();
  Procedure Arrange();
  Procedure UpdateImage();
end;

implementation
uses uClient,SysUtils,Forms,Dialogs;
//=== Constructor ==============================================================
Constructor TImageMap.Create();
begin
  FImageBuffer := TImageBuffer.Create;
  FPosX:=500;
  FPosY:=500;
  FWidth :=53;
  FHeight:=38;
  Make;
  Arrange;
  UpdateImage;
end;
//=== Get Function =============================================================
function TImageMap.GetMap(x :Integer; y :Integer): TImage;
begin
  result := FImageMap[x,y];
end;
//=== Set Function =============================================================
procedure TImageMap.SetMap(x :Integer; y :Integer; Image :TImage);
begin
  FImageMap[x,y] := Image;
end;
//=== Make Function ============================================================
Procedure TImageMap.Make();
var x,y :Integer;
begin
//Number of Images
FQtdX := (Client.MapBox.Width  Div FWidth )+1;
FQtdY := (Client.MapBox.Height Div FHeight)+1;
SetLength(FImageMap, FQtdX+1,FQtdY+1);
//Create Map
for y := 0 to FQtdY do
  for x := 0 to FQtdX do begin
    FImageMap[x,y]:=TImage.Create(Client.MapBox);
    FImageMap[x,y].Parent:=Client.MapBox;
    FImageMap[x,y].OnMouseDown:=Client.MouseDown;
    FImageMap[x,y].OnMouseMove:=Client.MouseMove;
    FImageMap[x,y].OnMouseUp  :=Client.MouseUp  ;
    FImageMap[x,y].Picture:=FImageBuffer.GetImage('gras1');
  end;
//Coords Label
SetLength(FLabelCoordX,FQtdX+1);
SetLength(FLabelCoordY,FQtdY+1);
for x := 0 to High(FLabelCoordX) do begin
  FLabelCoordX[x]:= TLabel.Create(Client.MapBox);
  FLabelCoordX[x].Parent :=Client.MapBox;
end;
for y := 0 to High(FLabelCoordY) do begin
  FLabelCoordY[y]:= TLabel.Create(Client.MapBox);
  FLabelCoordY[y].Parent :=Client.MapBox;
end;

end;
//=== Arrange Function =========================================================
Procedure TImageMap.Arrange();
var x,y :Integer;
begin
//Reset Map Position
if FImageMap[0,0].Left<=-FWidth  then begin
  Client.MouseDownSpot.x := Client.MouseDownSpot.X - FWidth ;
  FPosX:=PosX+1;
  UpdateImage;
end;
if FImageMap[0,0].Top <=-FHeight then begin
  Client.MouseDownSpot.y := Client.MouseDownSpot.y - FHeight;
  FPosY:=PosY+1;
  UpdateImage;
end;
if FImageMap[0,0].Left> 0 then begin
  Client.MouseDownSpot.x := Client.MouseDownSpot.X + FWidth ;
  FPosX:=PosX-1;
  UpdateImage;
end;
if FImageMap[0,0].Top > 0 then begin
  Client.MouseDownSpot.y := Client.MouseDownSpot.y + FHeight;
  FPosY:=PosY-1;
  UpdateImage;
end;
//Map Limit
if FPosX<=0         then begin FImageMap[0,0].Left:=0; FPosX:=0        ; end;
if FPosY<=0         then begin FImageMap[0,0].Top :=0; FPosY:=0        ; end;
if FPosX>=999-FQtdX then begin FImageMap[0,0].Left:=0; FPosX:=999-FQtdX; end;
if FPosY>=999-FQtdY then begin FImageMap[0,0].Top :=0; FPosY:=999-FQtdY; end;
//Draw Map
for y := 0 to FQtdY do
  for x := 0 to FQtdX do begin
    FImageMap[x,y].Left:= FImageMap[0,0].Left + (x*FWidth );
    FImageMap[x,y].Top := FImageMap[0,0].Top  + (y*FHeight);
  end;
//Draw Coords Label
for x := 0 to High(FLabelCoordX) do begin
  FLabelCoordX[x].Caption:=IntToStr(FPosX+x);
  FLabelCoordX[x].Top := Client.MapBox.Height-20;
  FLabelCoordX[x].Left:= FImageMap[x,0].Left;
end;
for y := 0 to High(FLabelCoordY) do begin
  FLabelCoordY[y].Caption:=IntToStr(FPosX+y);
  FLabelCoordY[y].Top := FImageMap[0,y].Top;
  FLabelCoordY[y].Left:= 5;
end;
end;
//=== Update Image =============================================================
Procedure TImageMap.UpdateImage();
var x,y :Integer;
    name:String;
begin
for y := 0 to FQtdY do
  for x := 0 to FQtdX do begin
    if Client.Map[x+FPosX,y+FPosY]= nil then begin name:='gras1';
    end else begin
      //Bonus
      if Client.Map[x+FPosX,y+FPosY].Bonus<>0 then name:='v' else name:='b';
      //Points
           if Client.Map[x+FPosX,y+FPosY].Points <300   then name:=name+'1'
      else if Client.Map[x+FPosX,y+FPosY].Points <1000  then name:=name+'2'
      else if Client.Map[x+FPosX,y+FPosY].Points <3000  then name:=name+'3'
      else if Client.Map[x+FPosX,y+FPosY].Points <9000  then name:=name+'4'
      else if Client.Map[x+FPosX,y+FPosY].Points <11000 then name:=name+'5'
      else name:=name+'6';
      //Owner
      if Client.Map[x+FPosX,y+FPosY].Owner =0 then name:=name+'_left';
    end;
    FImageMap[x,y].Picture:=FImageBuffer.GetImage(name);
  end;
end;
end.
