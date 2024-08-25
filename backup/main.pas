unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus;

type

  { TForm1 }

  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    mnExit: TMenuItem;
    mnSelect: TMenuItem;
    mnInsert: TMenuItem;
    mnBubble: TMenuItem;
    mnShuffle: TMenuItem;
    mnSort: TMenuItem;
    mnFile: TMenuItem;
    PaintBox1: TPaintBox;
    procedure FormCreate(Sender: TObject);
    procedure mnBubbleClick(Sender: TObject);
    procedure mnExitClick(Sender: TObject);
    procedure mnInsertClick(Sender: TObject);
    procedure mnSelectClick(Sender: TObject);
    procedure mnShuffleClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  vector: array[1..8] of integer;

implementation

{$R *.lfm}

{ TForm1 }

{TForm1.PaintBox1Paint
Takes the current vector state and paint in in the paintbox control.}
procedure TForm1.PaintBox1Paint(Sender: TObject);
var
  Bitmap: TBitmap;
  rectangleHeight, rectangleWidth: integer;
  i: integer;
begin
  Bitmap := TBitmap.Create;
  // Initializes the Bitmap Size
  Bitmap.Height := PaintBox1.Height;
  Bitmap.Width := PaintBox1.Width;

  rectangleHeight := PaintBox1.Height;
  rectangleWidth := PaintBox1.Width div 8;

  //Draw the background in white
  Bitmap.Canvas.Pen.Color := clWhite; //Line Color
  Bitmap.Canvas.Brush.Color := clDefault; //Fill Color
  Bitmap.Canvas.Rectangle(0, 0, PaintBox1.Width, PaintBox1.Height);

  Bitmap.Canvas.Pen.Color := clBlack; //Line Color
  //Write some text, in this case an *
  //Define Font properties
  Bitmap.Canvas.Font.Name := 'Liberation Mono';
  Bitmap.Canvas.Font.Style := [fsBold];
  Bitmap.Canvas.Font.Size := 30;
  Bitmap.Canvas.Font.Color := clWhite;

  for i:=1 to 8 do
  begin
    // Draws squares
    Bitmap.Canvas.Brush.Color := RGBToColor(0, round((255/8)*vector[i]), round((255/8)*vector[i]) ); //Brush color
    Bitmap.Canvas.Rectangle((i-1)*rectangleWidth + 2, 2, (i-1)*rectangleWidth + rectangleWidth-2, rectangleHeight-2);
    //Write the vector values.
    //This is the link between the paintbox and the array that we want to show
    Bitmap.Canvas.TextOut((i-1)*rectangleWidth + 2 + rectangleWidth div 3, rectangleHeight div 6, IntToStr(vector[i]));
  end;
  PaintBox1.Canvas.Draw(0, 0, Bitmap);
  Bitmap.Free; //Free the memory used by the object Bitmap
end;

{TForm1.FormCreate
Initializes the vector.}
procedure TForm1.FormCreate(Sender: TObject);
var
i: integer; //For cycle index

begin
  randomize; //Initialize the random number generator
  for i:=1 to length(vector) do
      vector[i] := i;
end;

{TForm1.mnExitClick
Terminates the application.}
procedure TForm1.mnExitClick(Sender: TObject);
begin
     Application.Terminate;
end;

{TForm1.mnBubbleClick
This routine implements the bubble sort on the global variable vector.}
procedure TForm1.mnBubbleClick(Sender: TObject);
var
   i,j,             //For cycle index
   aux: integer;    //Auxiliary variable to help the switch of two array values
   switch: boolean; //There was some switch?
begin
     for j:= 1 to length(vector)-1 do
     begin
      switch:=False;
      for i:=1 to length(vector)-j do
         //Check if the next number is smaller to make a switch
         if vector[i] > vector[i+1] then
         begin
           //There's a switch here between vector[i] and vector[i+1]
           aux:=vector[i];
           vector[i] := vector[i+1];
           vector[i+1] := aux;
           switch:=true; //Ok there was a switch so the array was not sorted already
           //Update the paintbox
           PaintBox1.Invalidate;
           Application.ProcessMessages;
           Sleep(500);
         end;
      if not switch then
         //The array is sorted because in the last run no switch occurred
         //Break the cycle to stop the algorithm and prevent unnecessary comparisons
         break;
      end;
end;

{TForm1.mnInsertClick
This routine implements the insert sort on the global variable vector.}
procedure TForm1.mnInsertClick(Sender: TObject);
var
   aux,           //Auxiliary variable to help the switch of two array values
   i, j: integer; //For cycle index
begin
  for i:=2 to length(vector) do
  begin
     //Start at i position and compare with the previous number to evaluate when to make a switch
     for j:= i downto 2 do
     if (vector[j] < vector[j-1]) then
     begin
      //There's a switch here between vector[j] and vector[j-1]
       aux:=vector[j];
       vector[j] := vector[j-1];
       vector[j-1] := aux;
       PaintBox1.Invalidate;
       Application.ProcessMessages;
       Sleep(500);
     end
     else
         //The previous number is already smaller so break the cycle
         break;
  end;
end;

{TForm1.mnSelectClick
This routine implements the select sort on the global variable vector.}
procedure TForm1.mnSelectClick(Sender: TObject);
var
   aux,           //Auxiliary variable to help the switch of two array values
   i, j: integer; //For cycle index
begin
  for i:= 1 to length(vector)-1 do
  begin
   for j:=i+1 to length(vector) do
      //If the number at position j is smaller than the number at position i then make a switch
      if vector[j] < vector[i] then
      begin
        //There's a switch here between vector[j] and vector[i]
        aux:=vector[i];
        vector[i] := vector[j];
        vector[j] := aux;
        PaintBox1.Invalidate;
        Application.ProcessMessages;
        Sleep(500);
      end;
  end;
end;

{TForm1.mnShuffleClick
This routine will shuffle the vector entries.}
procedure TForm1.mnShuffleClick(Sender: TObject);
var
i, j, k, aux: integer;
begin
  //Shuffle values
  for i:=1 to length(vector) do
  begin
   //Pick j and k random numbers
    j:=random(length(vector))+1;
    repeat
        k:=random(length(vector))+1;
    until k<>j;
    //Switch the numbers
    aux:=vector[j];
    vector[j] := vector[k];
    vector[k] := aux;
    PaintBox1.Invalidate;
    Application.ProcessMessages;
    Sleep(100);
  end;
end;

end.

