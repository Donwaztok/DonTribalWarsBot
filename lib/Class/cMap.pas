unit cMap;

interface

uses cVillage;

type TMap = class
//=== Protected ================================================================
Protected
  FMap :Array[0..999,0..999] of TVillage;
  function GetMap(x :Integer; y :Integer): Tvillage;
  procedure SetMap(x :Integer; y :Integer; Village :Tvillage);
//=== Public ===================================================================
Public
  property Map[x :Integer; y :Integer] :Tvillage read GetMap write SetMap; default;
end;

implementation
//=== Get Function =============================================================
function TMap.GetMap(x :Integer; y :Integer): Tvillage;
begin
  result := Self.FMap[x,y];
end;
//=== Set Function =============================================================
procedure TMap.SetMap(x :Integer; y :Integer; Village :Tvillage);
begin
  Self.FMap[x,y] := Village;
end;

end.
