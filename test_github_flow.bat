@echo off
REM ============================================================================
REM Script para testar o fluxo Git + GitHub Actions
REM ============================================================================

echo.
echo ========================================
echo 🚀 TESTE DO FLUXO GIT + GITHUB ACTIONS
echo ========================================

echo.
echo [1/6] Verificando estrutura do projeto...
if not exist ".git" (
    echo ❌ Este diretorio nao e um repositorio Git!
    echo Execute: git init
    echo Execute: git remote add origin <URL_DO_SEU_REPO>
    pause
    exit /b 1
)

if not exist ".github\workflows\ci.yml" (
    echo ❌ Pipeline CI/CD nao encontrado!
    pause
    exit /b 1
)

echo ✅ Estrutura basica OK

echo.
echo [2/6] Verificando status do Git...
git status
if %errorlevel% neq 0 (
    echo ❌ Erro ao verificar status do Git
    pause
    exit /b 1
)

echo.
echo [3/6] Verificando conexao com o repositorio remoto...
git remote -v
if %errorlevel% neq 0 (
    echo ❌ Nenhum repositorio remoto configurado!
    echo Execute: git remote add origin <URL_DO_SEU_REPO>
    pause
    exit /b 1
)

echo.
echo [4/6] Verificando branches locais e remotos...
git branch -a
echo.
echo Branch atual:
git branch --show-current

echo.
echo [5/6] Verificando ultimo commit...
git log --oneline -5

echo.
echo [6/6] Verificando se ha mudancas pendentes...
git diff --quiet
if %errorlevel% neq 0 (
    echo ⚠️  Ha mudancas nao commitadas:
    git status --porcelain
    echo.
    echo Voce pode:
    echo   - git add . && git commit -m "Sua mensagem"
    echo   - git stash (para guardar temporariamente)
    echo   - git checkout -- . (para descartar mudancas)
) else (
    echo ✅ Nenhuma mudanca pendente
)

echo.
echo ========================================
echo ✅ VERIFICACAO CONCLUIDA
echo ========================================
echo.
echo PROXIMOS PASSOS PARA TESTAR O FLUXO:
echo.
echo 1. Certifique-se de que o repositorio esta no GitHub
echo 2. Configure a protecao da branch 'main' (veja FLUXO-GITHUB.md)
echo 3. Execute o teste pratico com: test_feature_branch.bat
echo.
pause
