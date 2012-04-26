require 'mysql2'
require 'open3'

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

        c.desc "Dont create DB user"
        c.switch [:'no-user']

        c.desc "DB Username"
        c.arg_name "USER"
        c.default_value 'user'
        c.flag [:'db-username']

        c.desc "DB Password"
        c.arg_name "PASSWORD"
        c.default_value 'password'
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
      dump = @args.first

      log "Will restore '#{dump}' to database '#{@options[:db]}'. This may take some time."

      conn = Mysql2::Client.new(:host => "localhost", :username => @global[:username], :password => @global[:password])
      verbose "Connected to #{conn.server_info}"

      conn.query "drop database if exists #{@options[:db]}"
      conn.query "create database #{@options[:db]}"
      unless @options[:'no-user']
        conn.query "grant all privileges ON #{@options[:db]}.* TO '#{@options[:'db-username']}'@'%' IDENTIFIED BY '#{@options[:'db-password']}' with grant OPTION;"
      else
        verbose "SKIP creating DB user (as requested)."
      end
      conn.close
      verbose "Database created, user rights granted."

      zcat = ["zcat", dump]
      mysql = [ "mysql", "--user=#{@options[:'db-username']}", "--password=#{@options[:'db-password']}", @options[:db] ]
      Open3.pipeline(zcat, mysql).each do |s|
        raise "Process failed: #{s.exitstatus}" unless s.exitstatus == 0
      end
    end
  end
end
