# 📝 Lista de Tarefas - Flask Web App

Uma aplicação web simples e moderna para gerenciamento de tarefas, desenvolvida com Flask, Bootstrap e SQLite.

## 🚀 Funcionalidades

- ✅ **Criação de Tarefas**: Adicione novas tarefas com título, descrição, prioridade e status
- 📋 **Visualização**: Lista organizada por prioridade (Alta → Média → Baixa)
- ✏️ **Edição**: Modifique tarefas existentes
- 🗑️ **Exclusão**: Remova tarefas indesejadas
- ✔️ **Marcar como Concluída**: Atualize o status rapidamente
- 🔍 **Filtros**: Filtre por status e prioridade
- 📱 **Interface Responsiva**: Design moderno com Bootstrap
- 🔌 **API REST**: Endpoints para integração

## 🛠️ Tecnologias Utilizadas

- **Backend**: Python 3.9+ + Flask
- **Frontend**: HTML5, CSS3, Bootstrap 5, Font Awesome
- **Banco de Dados**: SQLite
- **ORM**: SQLAlchemy
- **Testes**: Robot Framework + Selenium
- **CI/CD**: GitHub Actions

## 🚀 Setup Rápido para Desenvolvedores

### Pré-requisitos
- Python 3.8 ou superior instalado
- Git instalado

### Passo a Passo - Primeira Execução

#### 1. Clonar o Repositório
```bash
git clone <URL_DO_REPOSITORIO>
cd Grupo-GCC-1905
```

#### 2. Executar o Script de Inicialização

**Windows:**
```bash
run.bat
```

**Linux/macOS:**
```bash
chmod +x run.sh
./run.sh
```

> 💡 **O script automaticamente vai:**
> - Criar o ambiente virtual (se não existir)
> - Ativar o ambiente virtual
> - Instalar todas as dependências
> - Iniciar a aplicação

#### 3. Acessar a Aplicação

A aplicação estará disponível em: `http://localhost:5000`

### 🧪 Executar Testes

1. **Certifique-se que a aplicação está rodando**
2. **Abra um novo terminal** e execute:

```bash
run_tests.bat  # Windows
```

### 📂 Scripts Disponíveis

| Script | Descrição |
|--------|-----------|
| `run.bat` / `run.sh` | Executa a aplicação (com setup automático) |
| `run_tests.bat` | Executa os testes Robot Framework |
| `check_setup.bat` / `check_setup.sh` | Verifica se o ambiente está configurado |

### 📁 Estrutura do Projeto

```
Grupo-GCC-1905/
├── app/
│   ├── templates/               # Templates HTML
│   ├── static/                  # CSS, JS, imagens
│   ├── instance/                # Banco de dados SQLite
│   └── main.py                  # Aplicação Flask principal
├── tests/
│   └── test_tasks.robot         # Testes automatizados
├── .github/
│   └── workflows/
│       └── ci.yml               # Pipeline CI/CD
├── .gitignore                   # Arquivos ignorados pelo Git
├── requirements.txt             # Dependências Python
├── run.bat / run.sh            # Scripts de execução
└── README.md                    # Esta documentação
```

### ❗ Problemas Comuns

| Problema | Solução |
|----------|---------|
| `python: command not found` | Instale Python ou use `python3` |
| `pip: command not found` | Instale pip: `python -m ensurepip` |
| `Porta 5000 em uso` | Mude a porta no `app/main.py` |
| `ModuleNotFoundError` | Execute `pip install -r requirements.txt` |

### 🔧 Verificação de Ambiente

Para verificar se tudo está configurado:

**Windows:**
```bash
check_setup.bat
```

**Linux/macOS:**
```bash
chmod +x check_setup.sh
./check_setup.sh
```

### 📱 Testando se Funciona

1. **Acesse:** `http://localhost:5000`
2. **Clique em:** "Nova Tarefa"
3. **Preencha:** Título = "Teste"
4. **Clique em:** "Salvar Tarefa"
5. **Verifique:** Se a tarefa aparece na lista ✅

## 🎯 Como Usar

### Interface Web

1. **Acessar a aplicação**: Abra `http://localhost:5000` no navegador
2. **Criar tarefa**: Clique em "Nova Tarefa" e preencha os campos
3. **Visualizar tarefas**: Na página inicial, veja todas as tarefas organizadas por prioridade
4. **Filtrar**: Use os filtros por status e prioridade
5. **Editar**: Clique no ícone de edição (✏️) na linha da tarefa
6. **Concluir**: Clique no ícone de check (✅) para marcar como concluída
7. **Excluir**: Clique no ícone de lixeira (🗑️) para remover

### API REST

A aplicação oferece uma API REST completa:

#### Endpoints Disponíveis

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/tasks` | Lista todas as tarefas |
| POST | `/api/tasks` | Cria uma nova tarefa |
| GET | `/api/tasks/<id>` | Busca tarefa por ID |
| PUT | `/api/tasks/<id>` | Atualiza uma tarefa |
| DELETE | `/api/tasks/<id>` | Exclui uma tarefa |

#### Exemplo de Uso da API

**Criar uma tarefa:**
```bash
curl -X POST http://localhost:5000/api/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "titulo": "Minha tarefa",
    "descricao": "Descrição da tarefa",
    "prioridade": "Alta",
    "status": "Pendente"
  }'
```

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'TASK-XXX: Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 👥 Autores

- **Grupo GCC-1905** - UniFil - Desenvolvimento inicial

---

⭐ Se este projeto foi útil, considere dar uma estrela no repositório!
