*** Settings ***
Documentation     Testes automatizados para a aplicação de Lista de Tarefas
Library           SeleniumLibrary
Library           RequestsLibrary
Library           Collections
Suite Setup       Setup Test Suite
Suite Teardown    Teardown Test Suite

*** Variables ***
${SERVER_URL}          http://localhost:5000
${BROWSER}             Chrome
${DELAY}               0.5

*** Test Cases ***
Teste 01 - Verificar se a aplicação está funcionando
    [Documentation]    Verifica se a página inicial está carregando corretamente
    [Tags]             smoke
    Open Browser       ${SERVER_URL}    ${BROWSER}
    Wait Until Element Is Visible    css:h1
    Page Should Contain    Minhas Tarefas
    Page Should Contain    Nova Tarefa
    Close Browser

Teste 02 - Criar nova tarefa com sucesso
    [Documentation]    Testa a criação de uma nova tarefa
    [Tags]             crud
    Open Browser       ${SERVER_URL}    ${BROWSER}
    Click Link         Nova Tarefa
    Input Text         id:titulo    Tarefa de Teste Automatizado
    Input Text         id:descricao    Esta é uma tarefa criada durante o teste automatizado
    Select From List By Value    id:prioridade    Alta
    Select From List By Value    id:status    Pendente
    Click Button       css:button[type="submit"]
    Wait Until Page Contains    Tarefa criada com sucesso!
    Page Should Contain    Tarefa de Teste Automatizado
    Close Browser

Teste 03 - Editar tarefa existente
    [Documentation]    Testa a edição de uma tarefa existente
    [Tags]             crud
    # Primeiro cria uma tarefa
    Create Test Task    Tarefa para Editar    Descrição original
    Open Browser       ${SERVER_URL}    ${BROWSER}
    Click Element      css:a[title="Editar tarefa"]
    Clear Element Text    id:titulo
    Input Text         id:titulo    Tarefa Editada pelo Teste
    Clear Element Text    id:descricao
    Input Text         id:descricao    Descrição modificada pelo teste
    Select From List By Value    id:prioridade    Baixa
    Select From List By Value    id:status    Em andamento
    Click Button       css:button[type="submit"]
    Wait Until Page Contains    Tarefa atualizada com sucesso!
    Page Should Contain    Tarefa Editada pelo Teste
    Page Should Contain    Descrição modificada
    Close Browser

Teste 04 - Marcar tarefa como concluída
    [Documentation]    Testa a marcação de tarefa como concluída
    [Tags]             crud
    # Primeiro cria uma tarefa
    Create Test Task    Tarefa para Concluir    Descrição da tarefa
    Open Browser       ${SERVER_URL}    ${BROWSER}
    Click Element      css:a[title="Marcar como concluída"]
    Handle Alert       ACCEPT
    Wait Until Page Contains    Tarefa marcada como concluída!
    Page Should Contain Element    css:.badge.bg-success
    Close Browser

Teste 05 - Excluir tarefa
    [Documentation]    Testa a exclusão de uma tarefa
    [Tags]             crud
    # Primeiro cria uma tarefa
    Create Test Task    Tarefa para Excluir    Descrição da tarefa
    Open Browser       ${SERVER_URL}    ${BROWSER}
    Click Element      css:a[title="Excluir tarefa"]
    Handle Alert       ACCEPT
    Wait Until Page Contains    Tarefa excluída com sucesso!
    Page Should Not Contain    Tarefa para Excluir
    Close Browser

Teste 06 - Filtrar tarefas por status
    [Documentation]    Testa o filtro por status
    [Tags]             filter
    # Cria tarefas com diferentes status
    Create Test Task Via API    Tarefa Pendente    Descrição    Média    Pendente
    Create Test Task Via API    Tarefa Em Andamento    Descrição    Média    Em andamento
    Create Test Task Via API    Tarefa Concluída    Descrição    Média    Concluída
    
    Open Browser       ${SERVER_URL}    ${BROWSER}
    Select From List By Value    id:status    Pendente
    Click Button       css:button[type="submit"]
    Page Should Contain    Tarefa Pendente
    Page Should Not Contain    Tarefa Em Andamento
    Page Should Not Contain    Tarefa Concluída
    Close Browser

Teste 07 - Filtrar tarefas por prioridade
    [Documentation]    Testa o filtro por prioridade
    [Tags]             filter
    # Cria tarefas com diferentes prioridades
    Create Test Task Via API    Tarefa Alta Prioridade    Descrição    Alta    Pendente
    Create Test Task Via API    Tarefa Média Prioridade    Descrição    Média    Pendente
    Create Test Task Via API    Tarefa Baixa Prioridade    Descrição    Baixa    Pendente
    
    Open Browser       ${SERVER_URL}    ${BROWSER}
    Select From List By Value    id:priority    Alta
    Click Button       css:button[type="submit"]
    Page Should Contain    Tarefa Alta Prioridade
    Page Should Not Contain    Tarefa Média Prioridade
    Page Should Not Contain    Tarefa Baixa Prioridade
    Close Browser

Teste 08 - API - Listar todas as tarefas
    [Documentation]    Testa a API para listar tarefas
    [Tags]             api
    Create Session     api    ${SERVER_URL}
    ${response}=       GET On Session    api    /api/tasks
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=           Set Variable    ${response.json()}
    Should Be True     isinstance($json, list)

Teste 09 - API - Criar nova tarefa
    [Documentation]    Testa a API para criar uma nova tarefa
    [Tags]             api
    Create Session     api    ${SERVER_URL}
    ${data}=           Create Dictionary    titulo=Tarefa via API    descricao=Criada pela API    prioridade=Alta    status=Pendente
    ${response}=       POST On Session    api    /api/tasks    json=${data}
    Should Be Equal As Strings    ${response.status_code}    201
    ${json}=           Set Variable    ${response.json()}
    Should Be Equal    ${json['titulo']}    Tarefa via API

Teste 10 - API - Buscar tarefa por ID
    [Documentation]    Testa a API para buscar uma tarefa específica
    [Tags]             api
    ${task_id}=        Create Test Task Via API    Tarefa para Buscar    Descrição    Média    Pendente
    Create Session     api    ${SERVER_URL}
    ${response}=       GET On Session    api    /api/tasks/${task_id}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=           Set Variable    ${response.json()}
    Should Be Equal    ${json['titulo']}    Tarefa para Buscar

*** Keywords ***
Setup Test Suite
    [Documentation]    Configurações iniciais para os testes
    Set Selenium Speed    ${DELAY}
    # Limpa as tarefas existentes antes de começar os testes
    Clear All Tasks

Teardown Test Suite
    [Documentation]    Limpeza após os testes
    # Limpa as tarefas criadas durante os testes
    Clear All Tasks

Create Test Task
    [Arguments]    ${titulo}    ${descricao}
    [Documentation]    Cria uma tarefa através da interface web
    Open Browser       ${SERVER_URL}    ${BROWSER}
    Click Link         Nova Tarefa
    Input Text         id:titulo    ${titulo}
    Input Text         id:descricao    ${descricao}
    Click Button       css:button[type="submit"]
    Close Browser

Create Test Task Via API
    [Arguments]    ${titulo}    ${descricao}    ${prioridade}    ${status}
    [Documentation]    Cria uma tarefa através da API e retorna o ID
    Create Session     api    ${SERVER_URL}
    ${data}=           Create Dictionary    titulo=${titulo}    descricao=${descricao}    prioridade=${prioridade}    status=${status}
    ${response}=       POST On Session    api    /api/tasks    json=${data}
    ${json}=           Set Variable    ${response.json()}
    [Return]           ${json['id']}

Clear All Tasks
    [Documentation]    Remove todas as tarefas do banco de dados
    Create Session     api    ${SERVER_URL}
    ${response}=       GET On Session    api    /api/tasks    expected_status=any
    Run Keyword If     ${response.status_code} == 200    Clear Tasks From Response    ${response.json()}

Clear Tasks From Response
    [Arguments]    ${tasks}
    [Documentation]    Remove todas as tarefas da lista fornecida
    Create Session     api    ${SERVER_URL}
    FOR    ${task}    IN    @{tasks}
        ${response}=    DELETE On Session    api    /api/tasks/${task['id']}    expected_status=any
    END
