#!/bin/bash
# ============================================================================
# Script para criar e testar uma feature branch completa (versão Linux/macOS)
# Este script simula o fluxo real: feature → PR → CI → merge
# ============================================================================

echo ""
echo "============================================"
echo "🔄 TESTE COMPLETO DO FLUXO FEATURE BRANCH"
echo "============================================"

read -p "Digite o nome da feature (ex: adicionar-prioridade): " feature_name
if [ -z "$feature_name" ]; then
    echo "❌ Nome da feature é obrigatório!"
    exit 1
fi

echo ""
echo "[1/8] Verificando se estamos na branch main/develop..."
current_branch=$(git branch --show-current)

if [[ "$current_branch" != "main" && "$current_branch" != "develop" ]]; then
    echo "⚠️  Você não está na branch main ou develop: $current_branch"
    echo "Mudando para main..."
    git checkout main
    if [ $? -ne 0 ]; then
        echo "❌ Erro ao mudar para main"
        exit 1
    fi
    current_branch="main"
fi

echo "✅ Na branch base: $current_branch"

echo ""
echo "[2/8] Sincronizando com o repositório remoto..."
git pull origin $current_branch
if [ $? -ne 0 ]; then
    echo "❌ Erro ao sincronizar com remoto"
    exit 1
fi

echo "✅ Sincronizado com remoto"

echo ""
echo "[3/8] Criando nova branch: feature/$feature_name..."
git checkout -b feature/$feature_name
if [ $? -ne 0 ]; then
    echo "❌ Erro ao criar branch"
    exit 1
fi

echo "✅ Branch criada: feature/$feature_name"

echo ""
echo "[4/8] Fazendo uma mudança de exemplo..."
# Adiciona uma nova rota de exemplo para testar
cat >> app/main.py << EOF

# Feature: $feature_name
@app.route('/health')
def health_check():
    return {'status': 'OK', 'feature': '$feature_name'}
EOF

echo "✅ Mudança adicionada ao app/main.py"

echo ""
echo "[5/8] Commitando mudanças..."
git add .
git commit -m "feat: adiciona endpoint /health para $feature_name

- Novo endpoint /health para verificação de status
- Retorna JSON com status OK
- Relacionado a feature: $feature_name"

if [ $? -ne 0 ]; then
    echo "❌ Erro ao fazer commit"
    exit 1
fi

echo "✅ Commit criado"

echo ""
echo "[6/8] Enviando branch para o repositório remoto..."
git push -u origin feature/$feature_name
if [ $? -ne 0 ]; then
    echo "❌ Erro ao enviar para remoto"
    echo "Verifique se o repositório remoto está configurado"
    exit 1
fi

echo "✅ Branch enviada para remoto"

echo ""
echo "[7/8] Gerando URL para criar Pull Request..."
repo_url=$(git remote get-url origin)

# Converte URL SSH para HTTPS se necessário
repo_url=${repo_url/git@github.com:/https://github.com/}
repo_url=${repo_url/.git/}

pr_url="$repo_url/compare/main...feature/$feature_name?quick_pull=1"

echo ""
echo "========================================"
echo "✅ BRANCH CRIADA COM SUCESSO!"
echo "========================================"
echo ""
echo "📋 INFORMAÇÕES DA FEATURE:"
echo "   Branch: feature/$feature_name"
echo "   Commit: Adicionado endpoint /health"
echo "   Arquivo: app/main.py"
echo ""
echo "🔗 CRIAR PULL REQUEST:"
echo "   URL: $pr_url"
echo ""
echo "📝 PRÓXIMOS PASSOS:"
echo "   1. Abra a URL acima no navegador"
echo "   2. Crie o Pull Request de feature/$feature_name para main"
echo "   3. Aguarde o pipeline CI/CD executar"
echo "   4. Verifique os checks de status"
echo "   5. Solicite review se necessário"
echo "   6. Faça merge quando aprovado"
echo ""
echo "🚨 IMPORTANTE:"
echo "   - O pipeline deverá executar automaticamente"
echo "   - Verifique se os jobs 'validate' e 'test' passaram"
echo "   - O bot comentará o status no PR"
echo ""

# Abrir URL automaticamente se possível
read -p "Abrir URL no navegador automaticamente? (s/n): " open_browser
if [[ "$open_browser" == "s" || "$open_browser" == "S" ]]; then
    if command -v xdg-open > /dev/null; then
        xdg-open "$pr_url"
    elif command -v open > /dev/null; then
        open "$pr_url"
    else
        echo "Copie e cole a URL manualmente no navegador"
    fi
fi

echo ""
echo "========================================"
echo "Para voltar a main: git checkout main"
echo "Para deletar a branch local: git branch -d feature/$feature_name"
echo "========================================"
echo ""
