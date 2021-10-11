unit potentio;

interface

uses
  SysUtils, Classes,Controls, Forms, Graphics,Messages,Windows, ExtCtrls,dialogs,Math;

type
  TPotentio = class(TCustomControl)
  private
    fBorderColor:TColor;
    fButtonColor:TColor;
    fStickColor:TColor;
    fStringsColor:TColor;  	
    fMin : Integer;
    fMax : Integer;
    fPos:Integer;
    fDelta:Extended;
    fVisiblePosition : Boolean;	
    Procedure SetMin(Value:Integer);
    Procedure SetMax(Value:Integer);
    Procedure SetPos(Value:Integer);
    Procedure SetButtonColor(Value:TColor);
    Procedure SetStickColor(Value:TColor);
    Procedure SetBorderColor(Value:TColor);
    Procedure SetStringsColor(Value:TColor);
    Procedure SetVisiblePosition(Value:Boolean);	
    procedure Paint; override;
    Procedure Resize; Override;
    procedure MouseDown(Button: TMouseButton;Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X,Y: Integer); override;
    procedure MouseUp(Button: TMouseButton;Shift: TShiftState; X, Y: Integer); override;
  protected
  public
   constructor Create(AOwner:TComponent); override;
   destructor Destroy; override;
  published
    Property ButtonColor : TColor Read fButtonColor Write SetButtonColor;
    Property StickColor : TColor Read fStickColor Write SetStickColor;
    Property BorderColor : TColor Read fBorderColor Write SetBorderColor;
    Property StringsColor : TColor Read fStringsColor Write SetStringsColor;	
    Property VisiblePosition : Boolean Read fVisiblePosition Write SetVisiblePosition;	
    Property Min : Integer Read fMin Write SetMin Default 0;
    Property Max : Integer Read fMax Write SetMax Default 100;
    Property Pos : Integer Read fPos Write SetPos Default 10;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;  
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('MUSIC_PRO', [TPotentio]);
end;

Procedure TPotentio.SetStickColor(Value:TColor);
Begin
  if fStickColor=Value then exit;
  fStickColor:=Value;
  Self.Repaint;
End;

Procedure TPotentio.SetButtonColor(Value:TColor);
Begin
  if fButtonColor=Value then exit;
  fButtonColor:=Value;
  Self.Repaint;
End;

Procedure TPotentio.SetBorderColor(Value:TColor);
Begin
  if fBorderColor=Value then exit;
  fBorderColor:=Value;
  Self.Repaint;
End;

Procedure TPotentio.SetStringsColor(Value:TColor);
Begin
  fStringsColor:=Value;
  Self.Repaint;
End;

Procedure TPotentio.Resize;
Begin
  Self.Height:=Self.Width;
  Self.Repaint;
End;

Procedure TPotentio.SetMin(Value:Integer);
Begin
  If (Value<fMax) and (Value<=fPos) Then
  fMin:=Value;
  fDelta:=(270*(fMin-fPos)/(fMin-fMax)-45)*PI/180;
  Self.Repaint;
End;

Procedure TPotentio.SetMax(Value:Integer);
Begin
  If (Value>fMin) and (Value>=fPos) Then
  fMax:=Value;
  fDelta:=(270*(fMin-fPos)/(fMin-fMax)-45)*PI/180;
  fPos:=Round(fMin-(fMin-fMax)*((180*fDelta/PI)+45)/270);
  Self.Repaint;
End;

Procedure TPotentio.SetPos(Value:Integer);
Begin
  If (Value<=fMin) Then fPos:=fMin;
  If (Value>=fMax) Then fPos:=FMax;
  fPos:=Value;
  fDelta:=(270*(fMin-fPos)/(fMin-fMax)-45)*PI/180;
  fPos:=Round(fMin-(fMin-fMax)*((180*fDelta/PI)+45)/270);
  Self.Repaint;
End;

Procedure TPotentio.SetVisiblePosition(Value:Boolean);
Begin
  fVisiblePosition:=Value;
  Self.Repaint;
End;

constructor TPotentio.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  Parent := TWinControl(AOwner);
  fMin:=0;
  fMax:=100;
  fPos:=0;
  Self.fButtonColor:=$002E2E2E;
  Self.fBorderColor:=$004B4B4B;
  Self.fStickColor:=ClWhite;
  doublebuffered  := True;
end;

Procedure TPotentio.Paint;
var
  Rect:TRect;
  R:Extended;
  Index,WidthText, HeightText:Integer;
begin
  if not assigned(Parent) then exit;
  with Self.Canvas Do
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
        Left:=(Self.Width Div 7);
        Right:=(6*Self.Width Div 7);
        Top:=(Self.Height Div 7);
        Bottom:=(6*Self.Height Div 7);
      End;
    Ellipse(Rect);

    //Cercle intérieur
    Brush.Color:=fButtonColor;
    With Rect Do
      Begin
        Left:=Round(2*Self.Width / 7);
        Right:=Round(5*Self.Width / 7);
        Top:=Round(2*Self.Height / 7);
        Bottom:=Round(5*Self.Height / 7);
      End;
    Ellipse(Rect);

    //Petits cercles
    Pen.Color:=Self.fStickColor;
    Brush.Color:=Self.fStickColor;
    R:=Round(2*Self.Width / 7);
    For Index:=-1 To 5 Do
      Begin
        Rect.Left:=Round(Self.Width Div 2-Round(R*Cos((45*Index)*PI/180))-Self.Width/25);
        Rect.Top:=Round(Self.Width Div 2-R*Sin((45*Index)*PI/180)-Self.Width/25);
        Rect.Right:=Round(Rect.Left+2*Self.Width/25);
        Rect.Bottom:=Round(Rect.Top+2*Self.Width/25);
        Ellipse(Rect);
      End;

     //Gestion de l'affichage des valeurs Min et Max
     Font.Size:=Self.Width Div 15;
     Font.Name:='Courrier';
     WidthText:=TextWidth(IntToStr(fMax));
     R:=Width Div 2;
     Brush.Style:=BsClear;
     Font.Color:=fStringsColor;
     TextOut(Round(R*(1-Cos(-45*PI/180))),Round(R*(1-Sin(-45*PI/180))),IntToStr(fMin));
     TextOut(Round(R*(1-Cos(225*PI/180)))-WidthText Div 2,Round(R*(1-Sin(-45*PI/180))),IntToStr(fMax));

    //Gestion du stick
    R:=(3*Width DIV 14);
      With Rect Do
        Begin
          MoveTo(Width Div 2, Height Div 2);
          LineTo(Self.Width Div 2-Round(R*Cos(fDelta)),Round(Self.Width Div 2-R*Sin(fDelta)));
        End;

    //Gestion de l'affichage de la valeur de Pos
    If VisiblePosition=True Then
      Begin
        WidthText:=TextWidth(IntToStr(fPos));
        HeightText:=TextHeight(IntToStr(fPos));
        Brush.Style:=BsSolid;
        Brush.Color:=fBorderColor;
        Rect.Left:=Self.Width Div 2 -TextWidth(IntToStr(1000)) Div 2;
        Rect.Right:=Self.Width Div 2 +TextWidth(IntToStr(1000)) Div 2;
        Rect.Top:=Self.Height - HeightText-3;
        Rect.Bottom:=Self.Height-1;
        Rectangle(Rect);         
        TextOut(Self.Width Div 2 - WidthText Div 2,Self.Height - HeightText-2,IntToStr(fPos));
      End;
              
     Refresh;
  end;
end;

destructor TPotentio.Destroy;
begin
  inherited;
end;

procedure TPotentio.MouseDown(Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
Var
 I : Extended;
Begin
  Inherited;
  If Shift=[SSLeft] Then
    Begin
      If X<>Self.Width Div 2 Then
        Begin
          I:=(Y-Self.Width Div 2)/(X-Self.Width Div 2);
          fDelta:=ArcTan(I);
          If x>Self.Width Div 2 Then fDelta:=FDelta+PI;
          If fDelta>=(225*PI/180) then fDelta:=(225*PI/180);
          If fDelta<=(-45*PI/180) then fDelta:=(-45*PI/180);
          fPos:=Round(fMin+(fMax-fMin)*(fDelta*180/PI+45) / 270);
          Self.Repaint;
        End;
    End;
End;

procedure TPotentio.MouseMove(Shift: TShiftState; X,Y: Integer);
Var
 I : Extended;
Begin
  Inherited;
  If Shift=[SSLeft] Then
    Begin
      If X<>Self.Width Div 2 Then
        Begin
          I:=(Y-Self.Width Div 2)/(X-Self.Width Div 2);
          fDelta:=ArcTan(I);
          If x>Self.Width Div 2 Then fDelta:=FDelta+PI;
          If fDelta>=(225*PI/180) then fDelta:=(225*PI/180);
          If fDelta<=(-45*PI/180) then fDelta:=(-45*PI/180);
          fPos:=Round(fMin+(fMax-fMin)*(fDelta*180/PI+45) / 270);
          Self.Repaint;
        End;
    End;
End;

procedure TPotentio.MouseUp(Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
Begin
  Inherited;
End;


end.
 