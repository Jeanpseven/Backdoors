#!/bin/bash

# Função para extrair cookies de uma URL
extract_cookies() {
    url=$1
    # Realiza uma solicitação GET para a URL e salva a resposta em um arquivo temporário
    tmp_file=$(mktemp)
    curl -s -c $tmp_file $url >/dev/null
    # Extrai os cookies da resposta usando grep
    cookies=$(grep -o -E '^Set-Cookie: .*' $tmp_file | sed 's/^Set-Cookie: //' | tr '\n' ';')
    echo "Cookies para $url:"
    echo "$cookies"
    # Remove o arquivo temporário
    rm $tmp_file
}

# Lista de URLs dos serviços
urls=(
    "https://www.google.com/"
    "https://mail.google.com/"
    "https://drive.google.com/"
    "https://www.instagram.com/"
    "https://www.facebook.com/"
    # Adicione mais URLs conforme necessário
)

# Itera sobre as URLs e extrai os cookies
for url in "${urls[@]}"; do
    extract_cookies "$url"
    echo ""
done
