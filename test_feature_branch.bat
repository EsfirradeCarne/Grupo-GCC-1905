@echo off
REM ============================================================================
REM Script para criar e testar uma feature branch completa
REM Este script simula o fluxo real: feature → PR → CI → merge
REM ============================================================================

echo.
echo ============================================
echo 🔄 TESTE COMPLETO DO FLUXO FEATURE BRANCH
echo ============================================

set /p feature_name="Digite o nome da feature (ex: adicionar-prioridade): "
if "%feature_name%"=="" (
    echo ❌ Nome da feature e obrigatorio!
    pause
    exit /b 1
)

echo.
echo [1/8] Verificando se estamos na branch main/develop...
git branch --show-current > temp.txt
set /p current_branch=<temp.txt
del temp.txt

if not "%current_branch%"=="main" if not "%current_branch%"=="develop" (
    echo ⚠️  Voce nao esta na branch main ou develop: %current_branch%
    echo Mudando para main...
    git checkout main
    if %errorlevel% neq 0 (
        echo ❌ Erro ao mudar para main
        pause
        exit /b 1
    )
)

echo ✅ Na branch base: %current_branch%

echo.
echo [2/8] Sincronizando com o repositorio remoto...
git pull origin %current_branch%
if %errorlevel% neq 0 (
    echo ❌ Erro ao sincronizar com remoto
    pause
    exit /b 1
)

echo ✅ Sincronizado com remoto

echo.
echo [3/8] Criando nova branch: feature/%feature_name%...
git checkout -b feature/%feature_name%
if %errorlevel% neq 0 (
    echo ❌ Erro ao criar branch
    pause
    exit /b 1
)

echo ✅ Branch criada: feature/%feature_name%

echo.
echo [4/8] Fazendo uma mudanca de exemplo...
REM Adiciona uma nova rota de exemplo para testar
echo. >> app\main.py
echo # Feature: %feature_name% >> app\main.py
echo @app.route('/health') >> app\main.py
echo def health_check(): >> app\main.py
echo     return {'status': 'OK', 'feature': '%feature_name%'} >> app\main.py

echo ✅ Mudanca adicionada ao app\main.py

echo.
echo [5/8] Commitando mudancas...
git add .
git commit -m "feat: adiciona endpoint /health para %feature_name%

- Novo endpoint /health para verificacao de status
- Retorna JSON com status OK
- Relacionado a feature: %feature_name%"

if %errorlevel% neq 0 (
    echo ❌ Erro ao fazer commit
    pause
    exit /b 1
)

echo ✅ Commit criado

echo.
echo [6/8] Enviando branch para o repositorio remoto...
git push -u origin feature/%feature_name%
if %errorlevel% neq 0 (
    echo ❌ Erro ao enviar para remoto
    echo Verifique se o repositorio remoto esta configurado
    pause
    exit /b 1
)

echo ✅ Branch enviada para remoto

echo.
echo [7/8] Gerando URL para criar Pull Request...
git remote get-url origin > temp.txt
set /p repo_url=<temp.txt
del temp.txt

REM Converte URL SSH para HTTPS se necessario
set repo_url=%repo_url:git@github.com:=https://github.com/%
set repo_url=%repo_url:.git=%

set pr_url=%repo_url%/compare/main...feature/%feature_name%?quick_pull=1

echo.
echo ========================================
echo ✅ BRANCH CRIADA COM SUCESSO!
echo ========================================
echo.
echo 📋 INFORMACOES DA FEATURE:
echo    Branch: feature/%feature_name%
echo    Commit: Adicionado endpoint /health
echo    Arquivo: app\main.py
echo.
echo 🔗 CRIAR PULL REQUEST:
echo    URL: %pr_url%
echo.
echo 📝 PROXIMOS PASSOS:
echo    1. Abra a URL acima no navegador
echo    2. Crie o Pull Request de feature/%feature_name% para main
echo    3. Aguarde o pipeline CI/CD executar
echo    4. Verifique os checks de status
echo    5. Solicite review se necessario
echo    6. Faca merge quando aprovado
echo.
echo 🚨 IMPORTANTE:
echo    - O pipeline devera executar automaticamente
echo    - Verifique se os jobs 'validate' e 'test' passaram
echo    - O bot comentara o status no PR
echo.

REM Abrir URL automaticamente se possivel
set /p open_browser="Abrir URL no navegador automaticamente? (s/n): "
if /i "%open_browser%"=="s" (
    start "" "%pr_url%"
)

echo.
echo ========================================
echo Para voltar a main: git checkout main
echo Para deletar a branch local: git branch -d feature/%feature_name%
echo ========================================
echo.
pause
