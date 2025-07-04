# Lista de Tarefas - Flask + Robot Framework + GitHub Actions

Aplicativo web simples de Lista de Tarefas demonstrando integração completa entre Flask, Robot Framework e GitHub Actions.

```

### Windows
```bash
check_setup.bat
run.bat
```

## Testes

### Executar localmente
```bash
# Windows
run_tests.bat

# Linux/Mac
robot --outputdir results tests/test_tasks.robot
```

### Casos de teste incluídos
- Abertura da aplicação
- Criação de nova tarefa
- Teste da API REST

## Pipeline CI/CD

O pipeline GitHub Actions executa:

**Em Pull Requests:**
- Validação de sintaxe
- Execução de testes Robot Framework
- Exibição de resultados

**Em push para main:**
- Todos os testes acima

## API

### Endpoints disponíveis
- `GET /` - Página principal
- `GET /api/tasks` - Listar tarefas (JSON)
- `POST /api/tasks` - Criar tarefa
- `PUT /api/tasks/<id>` - Atualizar tarefa
- `DELETE /api/tasks/<id>` - Deletar tarefa

**URL padrão**: http://localhost:5001

## Tecnologias

- **Backend**: Flask, SQLite
- **Frontend**: HTML5, Bootstrap 5, CSS3
- **Testes**: Robot Framework, SeleniumLibrary
- **CI/CD**: GitHub Actions
- **Versionamento**: Git/GitHub

## Troubleshooting

### Erro de porta ocupada
```bash
# Parar processos na porta 5001
netstat -ano | findstr :5001
taskkill /PID <PID> /F
```

### Problemas com dependências
```bash
pip install --upgrade pip
pip install -r requirements.txt
```

Teste Readme2