module MysqlTools
  class InitObfuscate < Command
    def run
      data = <<-EOS
		# -*- mode: ruby -*-
		{
		  :sitaddresses => {
		    :p_email      => { :type => :email },
		    :p_streetname => { :type => :string, :length => 8, :chars => MyObfuscate::USERNAME_CHARS }
		  }
		}
		EOS
      filename = File.expand_path @options[:'obfuscate-file']
      if File.exist? filename
        raise "File already exits. Please remove: '#{filename}'"
      end
      File.open(filename,'w', 0600) do |file|
        file.write(data.gsub("\t", ""))
        log "File created: '#{filename}'"
      end
    end
  end
end
