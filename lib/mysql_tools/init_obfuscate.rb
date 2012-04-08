module MysqlTools
  class InitObfuscate

#    # -*- mode: ruby -*-
#    {
#      :sitaddresses => {
#        :p_email      => { :type => :email },
#        :p_streetname => { :type => :string, :length => 8, :chars => MyObfuscate::USERNAME_CHARS }
#      }
#    }

    def self.init
      desc "Initialize obfuscate file"
      command :initobfuscate do |c|

        c.desc "Output filename"
        c.arg_name "FILENAME"
        c.default_value '~/.mysql-tools.obfuscate'
        c.flag [:'output-file']

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
      puts "Work work work."
      raise "Not implemented yet."
    end
  end
end
