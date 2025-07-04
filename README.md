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
- Upload de resultados

**Em push para main:**
- Todos os testes acima
- Criação de build
- Upload de artefatos

## API

### Endpoints disponíveis
- `GET /` - Página principal
- `GET /api/tasks` - Listar tarefas (JSON)
- `POST /api/tasks` - Criar tarefa
- `PUT /api/tasks/<id>` - Atualizar tarefa
- `DELETE /api/tasks/<id>` - Deletar tarefa

## Tecnologias

- **Backend**: Flask, SQLite
- **Frontend**: HTML5, Bootstrap 5, CSS3
- **Testes**: Robot Framework, SeleniumLibrary
- **CI/CD**: GitHub Actions
- **Versionamento**: Git/GitHub

## Troubleshooting

### Erro de porta ocupada
```bash
# Parar processos na porta 5000
netstat -ano | findstr :5000
taskkill /PID <PID> /F
```

### Erro no Robot Framework
- Verificar se Chrome está instalado
- Verificar se chromedriver está no PATH
- Executar testes com `--loglevel DEBUG`

### Problemas com dependências
```bash
pip install --upgrade pip
pip install -r requirements.txt
```

## Contribuição

1. Fork do repositório
2. Criar branch de feature
3. Fazer alterações
4. Executar testes localmente
5. Abrir Pull Request
6. Aguardar aprovação do CI/CD

---

**Objetivo**: Demonstrar fluxo completo de desenvolvimento com testes automatizados e CI/CD usando Robot Framework e GitHub Actions.
