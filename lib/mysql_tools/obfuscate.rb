module MysqlTools
  class Obfuscate

    def self.init
      desc "Obfuscate a database dump"
      long_desc <<-EOS
		Obfuscate a MySql database dump using 'my_obfuscate'.
		EOS
      arg_name "dump_file"
      command :obfuscate do |c|

        c.desc "Obfuscate filename"
        c.arg_name "FILENAME"
        c.default_value '~/.mysql-tools.obfuscate'
        c.flag [:'obfuscate-file']

        c.desc "Output filename"
        c.arg_name "FILENAME"
        c.default_value '#{dump_file}.obfuscate'
        c.flag [:'output-file']

        c.action do |global,command,args|
          MysqlTools::Obfuscate.new(global, command,args).run
        end
      end
    end

    def self.pre(global, options, args)
      verbose "Obfuscate command, pre check."
      raise "Dump file missing" if (args.nil? or args.first.nil?)
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
