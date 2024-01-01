#!/usr/bin/env ruby

# Detecta o navegador padrão
navegador = if system('command -v google-chrome &> /dev/null')
              `command -v google-chrome`.chomp
            elsif system('command -v firefox &> /dev/null')
              `command -v firefox`.chomp
            else
              puts "Nenhum navegador suportado encontrado."
              exit 1
            end

# Substitua 'https://web.whatsapp.com/' pelo link do WhatsApp Web
url = "https://web.whatsapp.com/"

# Abre o navegador com o link do WhatsApp Web
system("#{navegador} #{url}")
