#!/bin/bash

# Detecta o navegador padrÃ£o
if command -v google-chrome &> /dev/null
then
    navegador=$(command -v google-chrome)
elif command -v firefox &> /dev/null
then
    navegador=$(command -v firefox)
else
    echo "Nenhum navegador suportado encontrado."
    exit 1
fi

# Substitua 'https://web.whatsapp.com/' pelo link do WhatsApp Web
url="https://web.whatsapp.com/"

# Abre o navegador com o link do WhatsApp Web
$navegador $url
