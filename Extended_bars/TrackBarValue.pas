unit TrackBarValue;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, StdCtrls;

type
  TTrackBarValue = class(TCustomControl)
  private
    fLabel:TLabel;
    fColorBody:TColor;
    fColorText:TColor;
    fColorLines:TColor;
    fColorStick:TColor;
    fColorCentral:TColor;
    fMin:Cardinal;
    fMax:Cardinal;
    fPos:Cardinal;
    fFrequency:Cardinal;
    FOnChange: TNotifyEvent;
    Procedure SetColorBody(Value:TColor);
    Procedure SetColorText(Value:TColor);
    Procedure SetColorLines(Value:TColor);
    Procedure SetColorStick(Value:TColor);
    Procedure SetColorCentral(Value:TColor);
    Procedure SetMin(Value:Cardinal);
    Procedure SetMax(Value:Cardinal);
    Procedure SetPos(Value:Cardinal);
    Procedure SetFrequency(value:Cardinal);
  protected
    Procedure Paint; override;
    procedure MouseDown(Button: TMouseButton;Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X,Y: Integer); override;
  public
   constructor Create(AOwner:TComponent); override;
   destructor Destroy; override;
  published
    Property ColorBody : TColor Read fColorBody Write SetColorBody;
    Property ColorText : TColor Read fColorText Write SetColorText;
    Property ColorLines : TColor Read fColorLines Write SetColorLines;
    Property ColorStick : TColor Read fColorStick Write SetColorStick;
    Property ColorCentral : TColor Read fColorCentral Write SetColorCentral;
    Property Min : Cardinal Read fMin Write SetMin;
    Property Max : Cardinal Read fMax Write SetMax;
    Property Pos : Cardinal Read fPos Write SetPos;
    Property Frequency:Cardinal read fFrequency Write SetFrequency;
    property OnMouseDown;
    property OnMouseMove;
    property OnChange : TNotifyEvent read FOnChange write FOnChange;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('MUSIC_PRO', [TTrackBarValue]);
end;

constructor TTrackBarValue.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  Parent := TWinControl(AOwner);
  Self.DoubleBuffered:=True;
  fFrequency:=10;
  fMin:=0;
  fMax:=100;
  fPos:=100;
  fColorBody:=$0083500A;
  ColorCentral:=ClWhite;
  fColorText:=ClWhite;
  fColorStick:=ClRed;
  Self.Width:=75;
  Self.Height:=300;
  fLabel:=TLabel.Create(Self);
  fLabel.Parent:=Self;
end;

destructor TTrackBarValue.Destroy;
begin
  fLabel.Free;
  inherited;
end;

Procedure TTrackBarValue.SetColorBody(Value:TColor);
begin
  If Assigned(Self) Then
  Begin
    fColorBody:=Value;
    Self.Invalidate;
  End;
end;

Procedure TTrackBarValue.SetColorText(Value:TColor);
begin
  If Assigned(Self) Then
  Begin
    fColorText:=Value;
    Self.Invalidate;
  End;
end;

Procedure TTrackBarValue.SetColorLines(Value:TColor);
begin
  If Assigned(Self) Then
  Begin
    fColorLines:=Value;
    Self.Invalidate;
  End;
end;

Procedure TTrackBarValue.SetColorStick(Value:TColor);
begin
  If Assigned(Self) Then
  Begin
    fColorStick:=Value;
    Self.Invalidate;
  End;
end;

Procedure TTrackBarValue.SetColorCentral(Value:TColor);
begin
  If Assigned(Self) Then
  Begin
    fColorCentral:=Value;
    Self.Invalidate;
  End;
end;

Procedure TTrackBarValue.SetMin(Value:Cardinal);
begin
  If (Assigned(Self)) And (Value<fMax) And (Value<=fPos) Then
  Begin
    fMin:=Value;
    Self.Invalidate;
  End;
end;

Procedure TTrackBarValue.SetMax(Value:Cardinal);
begin
  If (Assigned(Self)) And (Value>fMin) And (Value>=fPos) Then
  Begin
    fMax:=Value;
    Self.Invalidate;
  End;
end;

Procedure TTrackBarValue.SetPos(Value:Cardinal);
begin
  If (Assigned(Self)) And (Value<=fMax) And (Value>=fMin) Then
  Begin
    fPos:=Value;
    Self.Invalidate;
  End;
end;

Procedure TTrackBarValue.SetFrequency(value:Cardinal);
begin
  If (Assigned(Self)) And (Value>0) Then
  Begin
    fFrequency:=Value;
    Self.Invalidate;
  End;
end;


Procedure TTrackBarValue.Paint;
Var
  Index:Integer;
  Xl,Xr,Yt,Yb:Cardinal;
  MaxPos,CurrentPos:real;
Begin
  Inherited;
  If Not Assigned(Self) Then Exit;
  With fLabel Do
    Begin
      fLabel.Font.Size:=Self.Width Div 4;
      Left:=0;
      Width:=Self.Width;
      Top:=Round(Self.Height-fLabel.Height );
      Color:=fColorText;
      Alignment:=taCenter;
      Caption:=format('%.3d', [Self.fPos]);
    End;    
  With Self.Canvas Do
    Begin
      Xl:=0;
      Xr:=Self.Width;
      Yt:=0;
      Yb:=Self.Height-fLabel.Height;
      Pen.Color:=ClBLack;
      Brush.Color:=Self.fColorBody;
      Brush.Style:=BsSolid;
      Pen.Width:=Self.Width Div 30;
      Rectangle(Xl,Yt,Xr,Yb);
      Pen.Color:=ColorCentral;
      Brush.Color:=ColorCentral;
      MoveTo(Self.Width Div 2, Round((Self.Height-fLabel.Height)*0.95));
      LineTo(Self.Width Div 2, Round((Self.Height-fLabel.Height)*0.05));
      MaxPos:=(Self.Height-fLabel.Height)*0.90;
      CurrentPos:=((1-(Self.fPos-Self.fMin) / (Self.fMax-Self.fMin))*MaxPos+Round(Self.Height*0.05));
      Xl:=Round(0.55*Self.Width / 2 );
      Xr:=Round(1.45*Self.Width / 2 );
      Yt:=Round(CurrentPos)+Self.Width div 8;
      Yb:=Round(CurrentPos)-Self.Width div 8;
      Pen.Color:=ClBLack;
      Brush.Color:=fColorStick;
      Rectangle(Xl,Yt,Xr,Yb);
      Pen.Width:=Self.Width Div 60;
      Pen.Color:=fColorLines;
      Brush.Color:=fColorLines;
      For Index:=fMin To fMax Do
        Begin
          If (Round(Index) Mod Self.fFrequency=0) Then
            Begin
              CurrentPos:=((Index-Round(Self.fMin)) / (Self.fMax-Self.fMin))*MaxPos+Self.Height*0.05;
              MoveTo(Pen.Width,Round(CurrentPos));
              LineTo(Round(Self.Width*0.15),Round(CurrentPos));
            End;
        End;
    End;
End;

procedure TTrackBarValue.MouseDown(Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
Begin
  Inherited;
   MouseMove(Shift,X,Y);
End;

procedure TTrackBarValue.MouseMove(Shift: TShiftState; X,Y: Integer);
Begin
  Inherited;
  If (Shift=[SsLeft])  Then
    Begin
      Self.fPos:=Round(Self.fMin+(Self.Max-Self.fMin)*(1-(Y-Round(Self.Height*0.05))/(Round((Self.Height*0.8)))));
      If (Self.fPos>=Self.fMin) and (Self.fPos<=Self.fMax) then Self.Invalidate;
      If Assigned(FOnChange) then FOnChange(Self);
    End;  
End;

end.
