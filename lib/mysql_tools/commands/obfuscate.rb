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
