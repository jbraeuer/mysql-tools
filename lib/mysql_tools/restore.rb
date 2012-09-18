require 'mysql2'
require 'open3'

module MysqlTools
  class Restore < Command
    def self.pre(global, options, args)
      verbose "Restore command, pre check: #{args.inspect}"
      raise "dump_file missing" if (args.nil? or args.first.nil?)
      true
    end

    # ----------------------------------------

    def run
      dump = @args.first

      log "Will restore '#{dump}' to database '#{@options[:db]}'. This may take some time."

      conn = Mysql2::Client.new(:host => "localhost", :username => @global[:username], :password => @global[:password])
      verbose "Connected to #{conn.server_info}"

      conn.query "drop database if exists #{@options[:db]}"
      conn.query "create database #{@options[:db]}"
      unless @options[:'no-user']
        conn.query "GRANT ALL PRIVILEGES ON #{@options[:db]}.* TO '#{@options[:'db-username']}'@'%'         IDENTIFIED BY '#{@options[:'db-password']}';"
        conn.query "GRANT ALL PRIVILEGES ON #{@options[:db]}.* TO '#{@options[:'db-username']}'@'localhost' IDENTIFIED BY '#{@options[:'db-password']}';"
        conn.query "FLUSH PRIVILEGES;"
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
