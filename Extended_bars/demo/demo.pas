unit demo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, TrackBarValue, SelectBouton, Potentio;

type
  TForm1 = class(TForm)
    Potentio1: TPotentio;
    SelectBouton1: TSelectBouton;
    TrackBarValue1: TTrackBarValue;
    procedure TrackBarValue1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.TrackBarValue1Change(Sender: TObject);
begin
 Potentio1.Pos:=TrackBarValue1.Pos;
end;

end.
