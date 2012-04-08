module MysqlTools
  class Backup

    def self.init
      desc "Backup a database"
      long_desc <<-EOS
		Dump the seletected database using 'mysqldump'.
		EOS
      arg_name "database_name"
      command :backup do |c|

        c.desc "Output filename"
        c.arg_name "FILENAME"
        c.default_value '#{database_name}-#{timestamp}.sql'
        c.flag [:'output-file']

        c.desc "Output path"
        c.arg_name "PATH"
        c.default_value '.'
        c.flag [:'output-path']

        c.action do |global,command,args|
          MysqlTools::Backup.new(global, command,args).run
        end
      end
    end

    def self.pre(global, options, args)
      verbose "Backup command, pre check."
      return false if (global[:username].nil? or
                       global[:password].nil? or
                       global[:host].nil?)
      return true
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
