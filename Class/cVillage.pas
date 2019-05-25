unit cVillage;

interface

type Tvillage = class
//=== Protected ================================================================
Protected
  fID     :Integer;
  fName   :String;
  fpos_x  :Integer;
  fpos_y  :Integer;
  fOwner  :Integer;
  fPoints :Integer;
  fBonus  :Integer;
//=== Public ===================================================================
public
  property ID     :Integer read fID     write fID    ;
  property Name   :String  read fName   write fName  ;
  property x      :Integer read fpos_x  write fpos_x ;
  property y      :Integer read fpos_y  write fpos_y ;
  property Owner  :Integer read fOwner  write fOwner ;
  property Points :Integer read fPoints write fPoints;
  property Bonus  :Integer read fBonus  write fBonus ;
  Constructor Create(ID :Integer; name :String; pos_x :Integer; pos_y :Integer; Owner :Integer; Points :Integer; Bonus :Integer);
end;

implementation
//=== Constructor ==============================================================
Constructor TVillage.Create(ID :Integer; name :String; pos_x :Integer;
  pos_y :Integer; Owner :Integer; Points :Integer; Bonus :Integer);
begin
  fID    := id    ;
  fName  := name  ;
  fpos_x := pos_x ;
  fpos_y := pos_y ;
  fOwner := Owner ;
  fPoints:= Points;
  fBonus := Bonus ;
end;

end.
