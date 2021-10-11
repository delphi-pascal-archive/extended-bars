unit SelectBouton;

interface

uses
  SysUtils, Classes, Controls, Graphics, Windows, Messages, Dialogs;

type
  TSelectBouton = class(TCustomControl)
  private
    fBorderColor:TColor;
    fButtonColor:TColor;
    fStickColor:TColor;
    fStringsColor:TColor;
    fDelta : Extended;
    fPositions:TStringList;
    Angular:Array of Extended;
    fPos:Integer;
    Procedure SetButtonColor(Value:TColor);
    Procedure SetStickColor(Value:TColor);
    Procedure SetBorderColor(Value:TColor);
    Procedure SetStringsColor(Value:TColor);
    Procedure SetPositions(Value:TStringList); virtual;
    Procedure SetPos(Value:Integer);    
    procedure Paint; Override;
    Procedure Resize; Override;
    procedure MouseDown(Button: TMouseButton;Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X,Y: Integer); override;
  Protected  
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  published
    Property ButtonColor : TColor Read fButtonColor Write SetButtonColor;
    Property StickColor : TColor Read fStickColor Write SetStickColor;
    Property BorderColor : TColor Read fBorderColor Write SetBorderColor;
    Property StringsColor : TColor Read fStringsColor Write SetStringsColor;
    Property Positions : TStringList Read fPositions Write SetPositions;
    Property Pos : Integer Read fPos Write SetPos Default 0;    
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('MUSIC_PRO', [TSelectBouton]);
end;

constructor TSelectBouton.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  If Assigned(AOwner) Then
    Begin
      fPositions:=TStringList.Create;
      Parent := TWinControl(AOwner);
      Self.fButtonColor:=$002E2E2E;
      Self.fBorderColor:=$004B4B4B;
      Self.fStickColor:=ClWhite;
      doublebuffered  := True;
    End;  
end;

destructor TSelectBouton.Destroy;
begin
  FreeAndNil(fPositions);
  inherited;
end;

procedure TSelectBouton.SetPositions(Value:TStringList);
begin
  FPositions.Assign(Value);
  Invalidate;
end;


Procedure TSelectBouton.SetStickColor(Value:TColor);
Begin
  fStickColor:=Value;
  Invalidate;
End;

Procedure TSelectBouton.SetButtonColor(Value:TColor);
Begin
  fButtonColor:=Value;
  Invalidate;
End;

Procedure TSelectBouton.SetBorderColor(Value:TColor);
Begin
  fBorderColor:=Value;
  Invalidate;
End;

Procedure TSelectBouton.SetStringsColor(Value:TColor);
Begin
  fStringsColor:=Value;
  Invalidate;
End;


Procedure TSelectBouton.Resize;
Begin
  Self.Height:=Self.Width;
  Invalidate;
End;

Procedure TSelectBouton.SetPos(Value:Integer);
Begin
  fPos:=Value;
  Invalidate;
End;

Procedure TSelectBouton.Paint;
var
  Rect:TRect;
  R,R1:Extended;
  Index:Integer;
  Pas,DecHz,DecVt : Extended;
begin
  Inherited;
  if not assigned(Parent) then exit;
  Finalize(Angular);
  Initialize(Angular);
  SetLength(Angular,fPositions.Count+1);
  Pas:=270/(fPositions.Count-1);
  For Index:=0 To fPositions.Count -1 Do
  Angular[Index]:=-45+Pas*Index;
  with Canvas Do
  begin
    Brush.Color := self.Color;
    Brush.Style := bsSolid;
    FillRect(Self.ClientRect);
    Brush.Style:=BsSolid;
    Pen.Width:=1;

    //Cercle extérieur
    Pen.Color:=ClBlack;
    Brush.Color:=fBorderColor;
    With Rect Do
      Begin
        Left:=(2*Self.Width Div 8);
        Right:=(6*Self.Width Div 8);
        Top:=(2*Self.Height Div 8);
        Bottom:=(6*Self.Height Div 8);
      End;
    Ellipse(Rect);

    //Cercle intérieur
    Brush.Color:=fButtonColor;
    With Rect Do
      Begin
        Left:=Round(3*Self.Width / 10);
        Right:=Round(7*Self.Width / 10);
        Top:=Round(3*Self.Height / 10);
        Bottom:=Round(7*Self.Height / 10);
      End;
    Ellipse(Rect);

    //Gestion des valeurs
    if fPositions.Count>1 Then
      Begin
        R:=Round(2*Self.Width Div 7);
        R1:=Round(1.85*Self.Width / 5);
        Pen.Width:=3;
        Pen.Color:=Self.fStringsColor;
        Brush.Color:=Self.fStringsColor;
        For Index:=0 To fPositions.Count-1 Do
          Begin
            MoveTo(Round(Self.Width Div 2-R*Cos(Angular[Index]*PI/180)),Round(Self.Width Div 2-R*Sin(Angular[Index]*PI/180)));
            LineTo(Round(Self.Width Div 2-R1*Cos(Angular[Index]*PI/180)),Round(Self.Width Div 2-R1*Sin(Angular[Index]*PI/180)));
            Brush.Style:=BsClear;
            Font.Size:=2;
            If Angular[Index]<90 Then
              Begin
                DecHz:=-TextWidth(fPositions.Strings[Index])*2;
                If Angular[Index]<=0 Then DecVt:=0
                Else DecVt:=-TextHeight(fPositions.Strings[Index]) ;
              End;
            If Angular[Index]>90 Then
              Begin
                DecHz:=TextWidth(fPositions.Strings[Index])*0.6;
                If Angular[Index]>=180 Then DecVt:=0
                Else DecVt:=-TextHeight(fPositions.Strings[Index]);
              End;
            If Angular[Index]=90 Then
              Begin
                DecHz:=-TextWidth(fPositions.Strings[Index]) Div 2;
                DecVt:=-TextHeight(fPositions.Strings[Index]);
              End;
            TextOut(Round(Self.Width Div 2-R1*Cos(Angular[Index]*PI/180)+DecHz),Round(Self.Width Div 2-R1*Sin(Angular[Index]*PI/180)+DecVt),fPositions.Strings[Index]);
	  End;
      End;

    //Gestion du stick
    Pen.Color:=Self.fStickColor;
    Brush.Color:=Self.fStickColor;
    R:=(3*Width DIV 18);
      With Rect Do
        Begin
          MoveTo(Width Div 2, Height Div 2);
          LineTo(Self.Width Div 2-Round(R*Cos(Angular[fPos]*PI/180)),Round(Self.Width Div 2-R*Sin(Angular[fPos]*PI/180)));
        End;
  end;
end;

procedure TSelectBouton.MouseDown(Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
Var
 I : Extended;
 Index:Cardinal;
Begin
  Inherited;
  If Shift=[SSLeft] Then
    Begin
      If X<>Self.Width Div 2 Then
        Begin
          I:=(Y-Self.Width Div 2)/(X-Self.Width Div 2);
          fDelta:=ArcTan(I);
          If x>Self.Width Div 2 Then fDelta:=FDelta+PI;
          fDelta:=fDelta*180/PI;
          If fPositions.Count>1 Then
          For Index:=0 To (fPositions.Count-1) Do
            Begin
              If (Angular[Index]<=fDelta) And (fDelta<=Angular[Index+1]) Then
                Begin
                  If (fDelta-Angular[Index]<Angular[Index+1]-fDelta) Then
                  fPos:=Index Else fPos:=Index+1;
                  Self.Repaint;
                End;
            End;
        End;
    End;
End;

procedure TSelectBouton.MouseMove(Shift: TShiftState; X,Y: Integer);
Var
 I: Extended;
 Index:Cardinal;
Begin
  Inherited;
  If Shift=[SSLeft] Then
    Begin
      If X<>Self.Width Div 2 Then
        Begin
          I:=(Y-Self.Width Div 2)/(X-Self.Width Div 2);
          fDelta:=ArcTan(I);
          If x>Self.Width Div 2 Then fDelta:=FDelta+PI;
          fDelta:=fDelta*180/PI;
          If fPositions.Count>1 Then
          For Index:=0 To (fPositions.Count-1) Do
            Begin
              If (Angular[Index]<=fDelta) And (fDelta<=Angular[Index+1]) Then
                Begin
                  If (fDelta-Angular[Index]<Angular[Index+1]-fDelta) Then
                  fPos:=Index Else fPos:=Index+1;
                  Self.Repaint;
                End;
            End;
        End;
    End;
End;

end.
