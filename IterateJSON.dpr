program IterateJSON;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  uIterateJSON in 'uIterateJSON.pas';

begin
  try
    TIterateJSON.Iterate();
    ReadLn;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
