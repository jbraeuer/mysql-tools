require 'open3'
require 'tempfile'

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

        c.desc "Limit"
        c.arg_name "ROWS"
        c.flag [:'limit']

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

    def setup_mysqldump(tempfile)
      content = <<-EOS
		[client]
		user="#{@global[:username]}"
		password="#{@global[:password]}"
		EOS
      tempfile.write(content.gsub(/^\t+/, ""))
      tempfile.size # will flush as side-effect

      limit = []
      limit << "--where=1 limit #{@options[:limit]}" unless @options[:limit].nil?

      [ "mysqldump", "--defaults-file=#{tempfile.path}",
        # consistent DB dumps
        "--single-transaction",
        # make dump "nicer", so my_obfuscate can read it and Ruby does not choke
        "--complete-insert", "--default-character-set=utf8", "--hex-blob" ] + limit
    end

    def run
      File.umask 0077

      timestamp = Time.now.strftime("%Y%m%d-%H%M%S")
      tempfile = Tempfile.new("mysql-tools")

      begin
        verbose "Using tempfile #{tempfile.path}"
        mysqldump = setup_mysqldump(tempfile)
        compress = ["nice", "pigz"]

        @args.each do |database_name|
          output_file = eval( '"' + @options[:'output-file'] + '"' )
          output = File.join(@options[:'output-path'], output_file)

          verbose  "Will backup database '#{database_name}'. Output to #{output}. Limit #{@options[:limit].nil? ? 'none' : @options[:limit]}."
          verbose "Will run: #{(mysqldump + [database_name]).inspect}; #{compress.inspect}"
          Open3.pipeline(mysqldump + [database_name], compress, :out => output, :in => "/dev/null").each do |s|
            unless s.exitstatus == 0
              File.unlink(output)
              raise "Process failed: #{s.exitstatus}"
            end
          end
        end
      ensure
        # make sure tempfile does not survive
        tempfile.close
        tempfile.unlink
      end
    end
  end
end
