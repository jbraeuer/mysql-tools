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
