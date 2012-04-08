module MysqlTools
  class Restore

    def self.init
      desc "Restore a database dump"
      long_desc <<-EOS
		Restore a database dump from file.
		EOS
      arg_name "dump_file"
      command :restore do |c|

        c.desc "Database"
        c.arg_name "DB"
        c.default_value 'test'
        c.flag [:db]

        c.desc "DB Username"
        c.arg_name "USER"
        c.default_value 'root'
        c.flag [:'db-username']

        c.desc "DB Password"
        c.arg_name "PASSWORD"
        c.default_value 'secret'
        c.flag [:'db-password']

        c.action do |global,command,args|
          MysqlTools::Restore.new(global, command,args).run
        end
      end
    end

    def self.pre(global, options, args)
      verbose "Restore command, pre check: #{args.inspect}"
      raise "dump_file missing" if (args.nil? or args.first.nil?)
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
