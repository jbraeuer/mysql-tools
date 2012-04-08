module MysqlTools
  class InitObfuscate

    def self.init
      desc "Initialize obfuscate file"
      command :initobfuscate do |c|

        c.desc "Output filename"
        c.arg_name "FILENAME"
        c.default_value '~/.mysql-tools.obfuscate'
        c.flag [:'obfuscate-file']

        c.action do |global,command,args|
          MysqlTools::InitObfuscate.new(global, command,args).run
        end
      end
    end

    def self.pre(global, options, args)
      verbose "InitObfuscate command, pre check."
      true
    end

    # ----------------------------------------

    def initialize(global, options, args)
      @global, @options, @args = global, options, args
    end

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
