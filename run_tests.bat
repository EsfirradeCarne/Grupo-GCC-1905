@echo off
echo Executando testes Robot Framework...
echo Certifique-se de que a aplicacao esteja rodando em http://localhost:5000
pause
"d:/Projects/UniFil/Grupo-GCC-1905/.venv/Scripts/robot.exe" --outputdir results tests/test_tasks.robot
pause