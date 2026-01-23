unit DelphiAIDev.Utils.GitHelper;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, IniFiles, System.StrUtils,
  System.Generics.Collections;

type
  TGitRepositoryInfo = record
    RepositoryPath: string;
    RelativeFilePath: string;
    RemoteUrl: string;
    UserName: string;
    IsGitRepository: Boolean;
  end;

  TGitHelper = class
  private
    class var
      FGitInfoCache: TDictionary<string, TGitRepositoryInfo>;
    class function FindGitRoot(const FilePath: string): string;
    class function GetRemoteUrl(const GitRoot: string): string;
    class function ReadGitConfig(const GitRoot, Section, Key: string): string;
    class constructor Create;
    class destructor Destroy;
  public
    class function GetGitInfo(const FullFilePath: string): TGitRepositoryInfo;
  end;

implementation

{ TGitHelper }

class constructor TGitHelper.Create;
begin
  FGitInfoCache := TDictionary<string, TGitRepositoryInfo>.Create;
end;

class destructor TGitHelper.Destroy;
begin
  FGitInfoCache.Clear;
  FGitInfoCache.Free;
  inherited;
end;

class function TGitHelper.GetGitInfo(const FullFilePath: string): TGitRepositoryInfo;
begin
  Result.IsGitRepository := False;

  if not FileExists(FullFilePath) and not DirectoryExists(FullFilePath) then
    Exit;

  // check cache
  var NormalizedPath := TPath.GetFullPath(FullFilePath).ToLower;
  if FGitInfoCache.TryGetValue(NormalizedPath, Result) then
    Exit;

  // get git root
  var GitRoot := FindGitRoot(FullFilePath);
  if GitRoot = '' then Exit;

  Result.IsGitRepository := True;
  Result.RepositoryPath := GitRoot;
  Result.RelativeFilePath := ExtractRelativePath(GitRoot, FullFilePath);
  Result.RemoteUrl := GetRemoteUrl(GitRoot);
  Result.UserName := ReadGitConfig(GitRoot, 'user', 'name');

  // add cache
  FGitInfoCache.AddOrSetValue(NormalizedPath, Result);
end;

class function TGitHelper.FindGitRoot(const FilePath: string): string;
var
  CurrentPath, CheckPath: string;
begin
  Result := '';

  if FileExists(FilePath) then
    CurrentPath := ExtractFilePath(FilePath)
  else if DirectoryExists(FilePath) then
    CurrentPath := IncludeTrailingPathDelimiter(FilePath)
  else
    Exit;

  CheckPath := CurrentPath;
  while CheckPath <> '' do begin
    // check .git
    if DirectoryExists(IncludeTrailingPathDelimiter(CheckPath) + '.git') then begin
      Result := IncludeTrailingPathDelimiter(CheckPath);
      Break;
    end;
    // check root
    if Length(CheckPath) < 4 then Break;
    // get parent
    CheckPath := ExtractFilePath(ExcludeTrailingPathDelimiter(CheckPath));
  end;
end;

class function TGitHelper.GetRemoteUrl(const GitRoot: string): string;
begin
  Result := ReadGitConfig(GitRoot, 'remote "origin"', 'url');
  if Result.Contains('@') then
   Result := Result.Substring(Result.IndexOf('@') + 1);
end;

class function TGitHelper.ReadGitConfig(const GitRoot, Section, Key: string): string;
var
  ConfigFile: string;
  IniFile: TIniFile;
begin
  Result := '';
  ConfigFile := GitRoot + '.git\config';

  if not FileExists(ConfigFile) then
    Exit;

  IniFile := TIniFile.Create(ConfigFile);
  try
    Result := IniFile.ReadString(Section, Key, '');
  finally
    IniFile.Free;
  end;
end;

end.
