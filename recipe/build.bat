@echo on
@setlocal EnableDelayedExpansion

go build -o="%LIBRARY_BIN%\%PKG_NAME%.exe" -ldflags="-s -X main.version=%PKG_VERSION%" .\cmd\%PKG_NAME% || goto :error
go-licenses save .\cmd\%PKG_NAME% --save_path=license-files ^
    --ignore github.com/golangci/golangci-lint ^
    --ignore github.com/ashanbrown/forbidigo ^
    --ignore github.com/ashanbrown/makezero || goto :error
xcopy /s %RECIPE_DIR%\license-files\* %SRC_DIR%\license-files || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
