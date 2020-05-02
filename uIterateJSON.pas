unit uIterateJSON;

interface

uses
  JSON, IOUtils, VCL.StdCtrls, System.Classes;

type
  TIterateJSON = class
    class procedure Iterate;
  private
    class function CreateJson: TJSONObject;
    class procedure GetJsonArr(jsonArr: TJSONArray);
    class function GetKeyValue(JsonObj: TJSONObject): TJSONObject;
    class procedure CreateJSONValueArray(o: TJSONObject; arr: TJSONArray);
    class function CreateArrayElem(Strings: TStrings): TJSONObject;
  end;

implementation

uses
  System.SysUtils;


class procedure TIterateJSON.Iterate;
var
  JSONObject : TJSONObject;
  jstr: string;
begin
  jstr :=
    '{' +
    '  "DataList": [' +
    '    {' +
    '      "Period": "201911",' +
    '      "CODE": "3",' +
    '      "SCR_ENG": "Parsed from string",' +
    '      "CODE1": "101",' +
    '      "SCR_ENG1": "Film, entertainment",' +
    '      "CODE2": null,' +
    '      "DTVAL_CO": "9222"' +
    '    },' +
    '    {' +
    '      "Period": "202004",' +
    '      "CODE": "4",' +
    '      "SCR_ENG": "Same as Code 3",' +
    '      "CODE1": "101",' +
    '      "SCR_ENG1": "Agriculture, foresty, hunting and fishery",' +
    '      "CODE2": null,' +
    '      "DTVAL_CO": "1686"' +
    '    }' +
    '  ],' +
    '  "Response": "success"' +
    '}';
  JSONObject := TJSONObject.Create;
  try
    if FileExists('json.txt') then
      //Creating object from file
      JSONObject := TJSONObject.ParseJSONValue(TFile.ReadAllBytes('json.txt'), 0) as TJSONObject
    else
      //Creating object  from text
      JSONObject := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(jstr), 0) as TJSONObject;

    GetKeyValue(JSONObject);
  finally
    JSONObject.Free;
  end;
  ReadLn;

  WriteLn('');
  WriteLn('Create and print JSON:');
  WriteLn('');
  GetKeyValue(CreateJSON);
end;

class function TIterateJSON.CreateJson: TJSONObject;
var
  jsonValue: TJSONValue;
  jsonArray: TJSONArray;
  jsonPair: TJSONPair;
begin
  Result := TJSONObject.Create;
  Result.Format(2);

  jsonArray := TJSONArray.Create;
  jsonPair := TJSONPair.Create('DataList', jsonArray);
  CreateJSONValueArray(Result, jsonArray);
  Result.AddPair(jsonPair);
end;

class procedure TIterateJSON.CreateJSONValueArray(o: TJSONObject; arr: TJSONArray);
var
  Strings: TStrings;
begin
  Strings := TStringList.Create;
  try
    Strings.AddPair('Period', '201703');
    Strings.AddPair('CODE', '1');
    Strings.AddPair('SCR_ENG', 'Active');
    Strings.AddPair('CODE1', '101');
    Strings.AddPair('SCR_ENG1', 'Agriculture, foresty, hunting and fishery');
    Strings.AddPair('CODE2', '');
    Strings.AddPair('DTVAL_CO', '3802');
    arr.AddElement(CreateArrayElem(Strings) as TJSONObject);

    Strings.Clear;
    Strings.AddPair('Period', '201703');
    Strings.AddPair('CODE', '2');
    Strings.AddPair('SCR_ENG', 'have not started activities');
    Strings.AddPair('CODE1', '101');
    Strings.AddPair('SCR_ENG1', 'Agriculture, foresty, hunting and fishery');
    Strings.AddPair('CODE2', '');
    Strings.AddPair('DTVAL_CO', '1686');
    arr.AddElement(CreateArrayElem(Strings) as TJSONObject);
  finally
    Strings.Free;
  end;
end;

class function TIterateJSON.CreateArrayElem(Strings: TStrings): TJSONObject;
var
  I: Integer;
  key: string;
begin
  Result := TJSONObject.Create;
  for I := 0 to Strings.Count - 1 do
  begin
    key := Strings.KeyNames[I];
    Result.AddPair(key, Strings.Values[key]);
  end;
end;

class function TIterateJSON.GetKeyValue(JsonObj: TJSONObject): TJSONObject;
var
  I: Integer;
  jsonStr: string;
  key: string;
  value: string;
begin
  for I := 0 to JsonObj.Count - 1 do
  begin
    key := JsonObj.Pairs[I].JSONString.Value;
    value := JsonObj.GetValue(key).Value;
    if value = '' then
    begin
      Write('Key: ' + key);
      jsonStr := JsonObj.GetValue(key).ToJSON.TrimLeft;
      if jsonStr.StartsWith('{') then
        GetKeyValue(JsonObj.GetValue(key) as TJSONObject)
      else
      if jsonStr.StartsWith('[') then
        GetJsonArr(JsonObj.GetValue(key) as TJSONArray);
    end else
      WriteLn('Key: ' + key + ', Value: ' + value);
  end;
end;

class procedure TIterateJSON.GetJsonArr(jsonArr: TJSONArray);
var
  J: Integer;
begin
  WriteLn('');
  for J := 0 to jsonArr.Count - 1 do
  begin
    WriteLn('[');
    if jsonArr.Get(0).ToJSON.TrimLeft.StartsWith('{') then
      GetKeyValue(jsonArr.Get(0) as TJSONObject)
    else
    if jsonArr.Get(0).ToJSON.TrimLeft.StartsWith('[') then
      GetJsonArr(jsonArr.Get(0) as TJSONArray);
    WriteLn(']');
  end;
end;

end.
