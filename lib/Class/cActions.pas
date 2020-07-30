unit cActions;

interface

uses Action, cScavenge;

type
  TActions = class

  Protected
    FTime: TDateTime;
    FAction: IAction;
    FStatus: String;
    FPriority: String;
  Public
    property time: TDateTime read FTime;
    property Action: IAction read FAction;
    property status: String read FStatus;
    property priority: String read FPriority;
    procedure executeAction();
    Constructor Create(time: TDateTime; Action: String; priority: String);
  end;

implementation

uses StrUtils;

constructor TActions.Create(time: TDateTime; Action: String; priority: String);
begin
  self.FTime := time;
  if (Action = 'Scavenge') then
    FAction := TScavenge.Create;
  FStatus := 'waiting';
  FPriority := priority;
end;

procedure TActions.executeAction();
begin

end;

end.
