#!/bin/bash

echo "================================================"
echo "     Lista de Tarefas - Flask Web App"
echo "================================================"
echo

# Verifica se o ambiente virtual existe
if [ ! -d ".venv" ]; then
    echo "⚠️  Ambiente virtual não encontrado!"
    echo
    echo "Criando ambiente virtual..."
    python3 -m venv .venv
    echo
    echo "Ativando ambiente virtual..."
    source .venv/bin/activate
    echo
    echo "Instalando dependências..."
    pip install -r requirements.txt
    echo
else
    echo "✅ Ativando ambiente virtual..."
    source .venv/bin/activate
    echo
fi

echo "🚀 Iniciando aplicação..."
echo
cd app
python main.py
