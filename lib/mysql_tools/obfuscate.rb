require 'my_obfuscate'
require 'erubis'
require 'zlib'

module MysqlTools
  class Obfuscate < Command

    def self.pre(global, options, args)
      verbose "Obfuscate command, pre check."
      raise "Dump file missing" if (args.nil? or args.first.nil?)
      true
    end

    # ----------------------------------------

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
