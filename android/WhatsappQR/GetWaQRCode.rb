

#!/usr/bin/env ruby

require 'msf/core'

class MetasploitModule < Msf::Post

 include Msf::Post::Common
 include Msf::Post::File

 # Configuração do módulo
 def initialize(info = {})
    super(update_info(info,
                      'Name' => 'Get WhatsApp Web QR',
                      'Description' => 'Abre o navegador com o link do WhatsApp Web',
                      'Author' => 'Jeanpseven',
                      'Platform' => 'Multi',
                      'Arch' => ARCH_X86))
 end

 # Ação principal do módulo
 def run
    # Detecta o navegador padrão
    navegador = if cmd_exec('command -v google-chrome &> /dev/null')
                 cmd_exec('command -v google-chrome').chomp
                elsif cmd_exec('command -v firefox &> /dev/null')
                 cmd_exec('command -v firefox').chomp
                else
                 print_error("Nenhum navegador suportado encontrado.")
                 return
                end

    # Substitua 'https://web.whatsapp.com/' pelo link do WhatsApp Web
    url = "https://web.whatsapp.com/"

    # Abre o navegador com o link do WhatsApp Web
    cmd_exec("#{navegador} #{url}")
 end
end
