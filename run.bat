@echo off
echo ================================================
echo     Lista de Tarefas - Flask Web App
echo ================================================
echo.

REM Verifica se o ambiente virtual existe
if not exist ".venv\" (
    echo ⚠️  Ambiente virtual nao encontrado!
    echo.
    echo Criando ambiente virtual...
    python -m venv .venv
    echo.
    echo Ativando ambiente virtual...
    call .venv\Scripts\activate.bat
    echo.
    echo Instalando dependencias...
    pip install -r requirements.txt
    echo.
) else (
    echo ✅ Ativando ambiente virtual...
    call .venv\Scripts\activate.bat
    echo.
)

echo 🚀 Iniciando aplicacao...
echo.
cd app
python main.py
