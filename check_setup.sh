#!/bin/bash

echo "================================================"
echo "   Verificador de Ambiente - Lista de Tarefas"
echo "================================================"
echo

echo "🔍 Verificando instalação..."
echo

# Verificar Python
echo "[1/6] Verificando Python..."
if command -v python3 &> /dev/null; then
    echo "✅ $(python3 --version)"
elif command -v python &> /dev/null; then
    echo "✅ $(python --version)"
else
    echo "❌ Python não encontrado!"
    echo "   Instale Python em: https://python.org"
    exit 1
fi
echo

# Verificar pip
echo "[2/6] Verificando pip..."
if command -v pip3 &> /dev/null; then
    echo "✅ $(pip3 --version | cut -d' ' -f1-2)"
elif command -v pip &> /dev/null; then
    echo "✅ $(pip --version | cut -d' ' -f1-2)"
else
    echo "❌ pip não encontrado!"
    echo "   Execute: python -m ensurepip --upgrade"
    exit 1
fi
echo

# Verificar ambiente virtual
echo "[3/6] Verificando ambiente virtual..."
if [ -d ".venv" ]; then
    echo "✅ Ambiente virtual encontrado"
else
    echo "⚠️  Ambiente virtual não encontrado"
    echo "   Execute: python3 -m venv .venv"
fi
echo

# Verificar dependências
echo "[4/6] Verificando dependências..."
if [ -f "requirements.txt" ]; then
    echo "✅ requirements.txt encontrado"
else
    echo "❌ requirements.txt não encontrado!"
    exit 1
fi
echo

# Verificar Flask
echo "[5/6] Verificando Flask..."
if python3 -c "import flask; print('✅ Flask versão:', flask.__version__)" 2>/dev/null; then
    :
else
    echo "❌ Flask não instalado!"
    echo "   Execute: pip install -r requirements.txt"
fi
echo

# Verificar estrutura do projeto
echo "[6/6] Verificando estrutura do projeto..."
if [ -f "app/main.py" ]; then
    echo "✅ Aplicação principal encontrada"
else
    echo "❌ app/main.py não encontrado!"
fi

if [ -d "app/templates" ]; then
    echo "✅ Templates encontrados"
else
    echo "❌ Pasta templates não encontrada!"
fi

if [ -d "app/static" ]; then
    echo "✅ Arquivos estáticos encontrados"
else
    echo "❌ Pasta static não encontrada!"
fi
echo

echo "================================================"
echo "              DIAGNÓSTICO COMPLETO"
echo "================================================"
echo
echo "💡 Se todos os itens estão OK, execute: ./run.sh"
echo "🔧 Se há problemas, consulte o README.md"
echo
