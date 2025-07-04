*** Settings ***
Documentation     Testes básicos para aplicação Lista de Tarefas
Library           RequestsLibrary
Suite Setup       Setup Test Suite
Suite Teardown    Teardown Test Suite

*** Variables ***
${SERVER_URL}          http://localhost:5002
${DELAY}               0.5

*** Test Cases ***
Teste 03 - API - Listar tarefas
    [Documentation]    Testa API REST
    [Tags]             api
    Create Session     api    ${SERVER_URL}
    ${response}=       GET On Session    api    /api/tasks
    Should Be Equal As Strings    ${response.status_code}    200

*** Keywords ***
Setup Test Suite
    [Documentation]    Configuração inicial
    Set Global Variable    ${DELAY}

Teardown Test Suite
    [Documentation]    Limpeza final
    Log    Testes finalizados
