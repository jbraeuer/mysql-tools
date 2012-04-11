require 'open3'

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
        c.default_value '#{database_name}-#{timestamp}.sql.gz'
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
      raise "Required parameter missing" if (global[:username].nil? or
                                             global[:password].nil? or
                                             global[:host].nil? or
                                             args.nil? or args.first.nil?)
      true
    end

    # ----------------------------------------

    def initialize(global, options, args)
      @global, @options, @args = global, options, args
    end

    def run
      @args.each do |database_name|
        mysqldump = ["mysqldump",
                     # consistent DB dumps
                     "--single-transaction",
                     # make dump "nicer", so my_obfuscate can read it and Ruby does not choke
                     "--complete-insert", "--default-character-set=utf8", "--hex-blob",
                     "--user=#{@global[:username]}", "--password=#{@global[:password]}", database_name]
        gzip = ["nice", "pigz"]

        timestamp = Time.now.strftime("%Y%m%d-%H%M%S")
        output_file = eval( '"' + @options[:'output-file'] + '"' )
        output = File.join(@options[:'output-path'], output_file)

        log "Will backup database '#{database_name}'. Output to #{output}"
        File.umask 0077
        Open3.pipeline(mysqldump, gzip, :out => output, :in => "/dev/null").each do |s|
          raise "Process failed: #{s.exitstatus}" unless s.exitstatus == 0
        end
      end
    end
  end
end
