@echo off
echo ================================================
echo   Verificador de Ambiente - Lista de Tarefas
echo ================================================
echo.

echo Verificando instalacao...
echo.

REM Verificar Python
echo [1/6] Verificando Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python nao encontrado!
    echo    Instale Python em: https://python.org
    goto :end
) else (
    for /f "tokens=*" %%i in ('python --version') do echo %%i
)
echo.

REM Verificar pip
echo [2/6] Verificando pip...
pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo pip nao encontrado!
    echo    Execute: python -m ensurepip --upgrade
    goto :end
) else (
    for /f "tokens=1,2" %%i in ('pip --version') do echo %%i %%j
)
echo.

REM Verificar ambiente virtual
echo [3/6] Verificando ambiente virtual...
if exist ".venv\" (
    echo ✅ Ambiente virtual encontrado
) else (
    echo ⚠️  Ambiente virtual nao encontrado
    echo    Execute: python -m venv .venv
)
echo.

REM Verificar dependencias
echo [4/6] Verificando dependencias...
if exist "requirements.txt" (
    echo ✅ requirements.txt encontrado
) else (
    echo ❌ requirements.txt nao encontrado!
    goto :end
)
echo.

REM Verificar Flask
echo [5/6] Verificando Flask...
python -c "import flask; print('✅ Flask versao:', flask.__version__)" 2>nul
if %errorlevel% neq 0 (
    echo ❌ Flask nao instalado!
    echo    Execute: pip install -r requirements.txt
) 
echo.

REM Verificar estrutura do projeto
echo [6/6] Verificando estrutura do projeto...
if exist "app\main.py" (
    echo ✅ Aplicacao principal encontrada
) else (
    echo ❌ app\main.py nao encontrado!
)

if exist "app\templates\" (
    echo ✅ Templates encontrados
) else (
    echo ❌ Pasta templates nao encontrada!
)

if exist "app\static\" (
    echo ✅ Arquivos estaticos encontrados
) else (
    echo ❌ Pasta static nao encontrada!
)
echo.

echo ================================================
echo              DIAGNOSTICO COMPLETO
echo ================================================
echo.
echo 💡 Se todos os itens estao OK, execute: run.bat
echo 🔧 Se ha problemas, consulte o README.md
echo.

:end
pause
