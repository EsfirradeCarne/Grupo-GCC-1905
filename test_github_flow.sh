#!/bin/bash
# ============================================================================
# Script para testar o fluxo Git + GitHub Actions (versão Linux/macOS)
# ============================================================================

echo ""
echo "========================================"
echo "🚀 TESTE DO FLUXO GIT + GITHUB ACTIONS"
echo "========================================"

echo ""
echo "[1/6] Verificando estrutura do projeto..."
if [ ! -d ".git" ]; then
    echo "❌ Este diretório não é um repositório Git!"
    echo "Execute: git init"
    echo "Execute: git remote add origin <URL_DO_SEU_REPO>"
    exit 1
fi

if [ ! -f ".github/workflows/ci.yml" ]; then
    echo "❌ Pipeline CI/CD não encontrado!"
    exit 1
fi

echo "✅ Estrutura básica OK"

echo ""
echo "[2/6] Verificando status do Git..."
git status
if [ $? -ne 0 ]; then
    echo "❌ Erro ao verificar status do Git"
    exit 1
fi

echo ""
echo "[3/6] Verificando conexão com o repositório remoto..."
git remote -v
if [ $? -ne 0 ]; then
    echo "❌ Nenhum repositório remoto configurado!"
    echo "Execute: git remote add origin <URL_DO_SEU_REPO>"
    exit 1
fi

echo ""
echo "[4/6] Verificando branches locais e remotos..."
git branch -a
echo ""
echo "Branch atual:"
git branch --show-current

echo ""
echo "[5/6] Verificando último commit..."
git log --oneline -5

echo ""
echo "[6/6] Verificando se há mudanças pendentes..."
if ! git diff --quiet; then
    echo "⚠️  Há mudanças não commitadas:"
    git status --porcelain
    echo ""
    echo "Você pode:"
    echo "  - git add . && git commit -m \"Sua mensagem\""
    echo "  - git stash (para guardar temporariamente)"
    echo "  - git checkout -- . (para descartar mudanças)"
else
    echo "✅ Nenhuma mudança pendente"
fi

echo ""
echo "========================================"
echo "✅ VERIFICAÇÃO CONCLUÍDA"
echo "========================================"
echo ""
echo "PRÓXIMOS PASSOS PARA TESTAR O FLUXO:"
echo ""
echo "1. Certifique-se de que o repositório está no GitHub"
echo "2. Configure a proteção da branch 'main' (veja FLUXO-GITHUB.md)"
echo "3. Execute o teste prático com: ./test_feature_branch.sh"
echo ""
