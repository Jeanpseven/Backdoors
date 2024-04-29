import requests
from urllib.parse import urlparse

# Lista de URLs dos serviços
urls = [
    'https://www.google.com/',
    'https://mail.google.com/',
    'https://drive.google.com/',
    'https://www.instagram.com/',
    'https://www.facebook.com/'
    # Adicione mais URLs conforme necessário
]

# Solicita os cookies para cada URL
for url in urls:
    # Extrai a URL base do site
    parsed_url = urlparse(url)
    base_url = f"{parsed_url.scheme}://{parsed_url.netloc}"

    # Realiza uma solicitação GET para a página alvo
    response = requests.get(url)

    # Verifica se a solicitação foi bem-sucedida
    if response.status_code == 200:
        # Obtém os cookies da resposta
        cookies = response.cookies
        
        # Itera sobre os cookies e imprime suas chaves e valores
        print(f"=== Cookies para {url} ===")
        for cookie in cookies:
            print(f"Cookie: {cookie.name}, Valor: {cookie.value}")

        # Você também pode salvar os cookies em um arquivo, se desejar
        with open('cookies.txt', 'a') as file:  # 'a' para modo de adição
            file.write(f"=== Cookies para {url} ===\n")
            for cookie in cookies:
                file.write(f"Cookie: {cookie.name}, Valor: {cookie.value}\n")
    else:
        print(f"Falha ao fazer a solicitação para {url}.")
