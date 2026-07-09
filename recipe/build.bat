@echo on
@setlocal EnableDelayedExpansion

for /f "usebackq delims=" %%i in (`powershell -NoProfile -Command "Get-Date -Format 'yyyy-MM-ddTHH:mm:ssZ' -AsUTC"`) do set "BUILD_DATE=%%i"
go build -o="%LIBRARY_BIN%\%PKG_NAME%.exe" -ldflags="-s -w -X main.version=%PKG_VERSION% -X main.date=%BUILD_DATE%" .\cmd\%PKG_NAME% || goto :error
go-licenses save .\cmd\%PKG_NAME% --save_path=license-files ^
    --ignore github.com/golangci/golangci-lint ^
    --ignore github.com/ashanbrown/forbidigo ^
    --ignore github.com/ashanbrown/makezero ^
    --ignore github.com/alecthomas/chroma || goto :error
xcopy /s %RECIPE_DIR%\license-files\* %SRC_DIR%\license-files || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
