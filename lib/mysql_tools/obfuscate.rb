require 'my_obfuscate'
require 'erubis'
require 'zlib'

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
        c.default_value '#{File.basename(dump_file).gsub("sql.gz", "sql.obfuscate.gz")}'
        c.flag [:'output-filename']

        c.desc "Output directory"
        c.arg_name "DIRECTORY"
        c.default_value '#{File.dirname(dump_file)}'
        c.flag [:'output-directory']

        c.desc "Table prefix"
        c.arg_name "PREFIX"
        c.default_value 'sit'
        c.flag [:'table-prefix']

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

    def map_options(opts)
      r = {}
      opts.each_pair do |k,v|
        r[k] = v unless k.is_a?(Symbol)
        r[k.to_s.gsub("-","_")] = v if k.is_a?(Symbol)
      end
      return r
    end

    def run
      obfuscate_tmpl = IO.read File.expand_path(@options[:'obfuscate-file'])
      obfuscate_def = Erubis::Eruby.new(obfuscate_tmpl).result(map_options(@options))
      obfuscate_hash = eval obfuscate_def

      @args.each do |dump_file|
        obfuscator = MyObfuscate.new(obfuscate_hash)

        input = Zlib::GzipReader.new File.open(File.expand_path(dump_file),'r')

        output_filename = eval( '"' + @options[:'output-filename'] + '"' )
        output_directory = eval( '"' + @options[:'output-directory'] + '"' )
        output_file = File.join(output_directory, output_filename)
        output = Zlib::GzipWriter.new File.open(output_file, 'w')

        obfuscator.obfuscate(input, output)

        input.close
        output.close
      end
    end
  end
end
