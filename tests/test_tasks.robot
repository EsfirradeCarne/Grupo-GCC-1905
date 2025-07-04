*** Settings ***
Documentation     Testes básicos para aplicação Lista de Tarefas
Library           SeleniumLibrary
Library           RequestsLibrary
Suite Setup       Setup Test Suite
Suite Teardown    Teardown Test Suite

*** Variables ***
${SERVER_URL}          http://localhost:5001
${BROWSER}             headlesschrome
${DELAY}               0.5

*** Test Cases ***
Teste 01 - Verificar aplicação funcionando
    [Documentation]    Verifica se a página inicial carrega
    [Tags]             smoke
    Open Browser       ${SERVER_URL}    ${BROWSER}
    Wait Until Element Is Visible    css:h1    timeout=10s
    Page Should Contain    Minhas Tarefas
    Close Browser

Teste 02 - Criar nova tarefa
    [Documentation]    Testa criação de tarefa via interface
    [Tags]             crud
    Open Browser       ${SERVER_URL}    ${BROWSER}
    Click Link         Nova Tarefa
    Input Text         id:titulo    Tarefa de Teste
    Input Text         id:descricao    Descrição de teste
    Click Button       css:button[type="submit"]
    Wait Until Page Contains    Tarefa criada com sucesso!    timeout=10s
    Close Browser

Teste 03 - API - Listar tarefas
    [Documentation]    Testa API REST
    [Tags]             api
    Create Session     api    ${SERVER_URL}
    ${response}=       GET On Session    api    /api/tasks
    Should Be Equal As Strings    ${response.status_code}    200

*** Keywords ***
Setup Test Suite
    [Documentation]    Configuração inicial
    Set Selenium Speed    ${DELAY}
    Set Selenium Timeout   10s

Teardown Test Suite
    [Documentation]    Limpeza final
    Close All Browsers
