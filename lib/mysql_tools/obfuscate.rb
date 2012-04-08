require 'my_obfuscate'
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
        c.default_value '#{dump_file.gsub(".gz", "")}.obfuscate.gz'
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
      obfuscate_def = IO.read File.expand_path(@options[:'obfuscate-file'])
      obfuscate_hash = eval obfuscate_def

      @args.each do |dump_file|
        obfuscator = MyObfuscate.new(obfuscate_hash)

        input = Zlib::GzipReader.new File.open(File.expand_path(dump_file),'r')

        output_file = eval( '"' + @options[:'output-file'] + '"' )
        output = Zlib::GzipWriter.new File.open(output_file, 'w')

        obfuscator.obfuscate(input, output)

        input.close
        output.close
      end
    end
  end
end
